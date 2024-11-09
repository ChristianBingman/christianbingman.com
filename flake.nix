{
  description = "A Nix-flake-based Node.js development environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import nixpkgs { inherit system; overlays = [ self.overlays.default ]; };
      });
    in
    {
      overlays.default = final: prev: rec {
        nodejs = prev.nodejs;
        yarn = (prev.yarn.override { inherit nodejs; });
        site = (prev.buildNpmPackage rec {
          pname = "personal-site";
          version = "1.0.0";
          src = ./.;
          npmDepsHash = "sha256-++OEQYqq5UTtkOdhfM+FJ9nIqIM7mxPLqx/r4iXhQ40=";
        }).overrideAttrs (prev: { installPhase = ''
          mv build $out
        '';});
        nginx-conf = prev.writeText "nginx.conf" ''
          user www www;
          daemon off;
          worker_processes  2;

          pid /dev/null;

          #                          [ debug | info | notice | warn | error | crit ]

          error_log  /dev/stderr  info;

          events {
              worker_connections   2000;
          }

          http {

              include       ${prev.nginx}/conf/mime.types;
              default_type  application/octet-stream;


              log_format main      '$remote_addr - $remote_user [$time_local] '
                                   '"$request" $status $bytes_sent '
                                   '"$http_referer" "$http_user_agent" '
                                   '"$gzip_ratio"';

              access_log /dev/stdout main;

              client_header_timeout  3m;
              client_body_timeout    3m;
              send_timeout           3m;

              client_header_buffer_size    1k;
              large_client_header_buffers  4 4k;

              gzip on;
              gzip_min_length  1100;
              gzip_buffers     4 8k;
              gzip_types       text/plain;

              output_buffers   1 32k;
              postpone_output  1460;

              sendfile         on;
              tcp_nopush       on;
              tcp_nodelay      on;

              keepalive_timeout  75 20;

              #lingering_time     30;
              #lingering_timeout  10;
              #reset_timedout_connection  on;


              server {
                listen 80;
                listen [::]:80;
                root ${final.site};
                index index.html;
                server_name christianbingman.com www.christianbingman.com;

                location / {
                  try_files $uri $uri/ =404;
                }

                location /healthz {
                  return 200;
                }
              }
          }
        '';
      };

      devShells = forEachSupportedSystem ({ pkgs }: let
          default = pkgs.mkShell {
            buildInputs = with pkgs; [ nodejs ];
          };
      in {
        inherit default;
      });

      packages = forEachSupportedSystem ({ pkgs }: {
        default = pkgs.site;
        docker = pkgs.dockerTools.buildImage {
          name = "registry.christianbingman.com/personal-site";
          tag = "latest";
          copyToRoot = pkgs.buildEnv {
            name = "image-root";
            paths = [
              (pkgs.buildEnv {
                name = "image-root";
                paths = with pkgs; [
                  bashInteractive
                  coreutils
                  curl
                ];
                pathsToLink = [ "/bin" ];
              })
              (pkgs.runCommand "www" {} ''
                mkdir -p $out/var/log/nginx
                mkdir $out/etc
                mkdir $out/tmp
                echo "www:x:1000:1000:www:/home/www:/bin/false" > $out/etc/passwd
                echo "www:x:1000:" > $out/etc/group
                echo "www:!:1::::::" > $out/etc/shadow
              '')
            ];
          };
          config = {
            Cmd = [ "${pkgs.nginx}/bin/nginx" "-c" "${pkgs.nginx-conf}" ];
          };
        };
      });
    };
}
