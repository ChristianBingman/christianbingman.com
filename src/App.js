import './App.css';
import Navbar from './Navbar';
import RoundedImage from './RoundedImage';
import ButtonFilled from './ButtonFilled';
import ButtonBorder from './ButtonBorder';
import { faCode, faPersonRays } from '@fortawesome/free-solid-svg-icons';

function App() {
  return (
    <div className="bg-home-gradient min-h-screen font-sans">
      <Navbar />
      <div className="flex min-h-[90vh]">
        {/* Left Section with Text */}
        <div className="flex-1 flex items-center justify-center ">
          <div className="max-w-lg">
            <h1 className="text-3xl font-bold mb-4">Hello 👋🏼! I’m Christian.</h1>
            <p className="text-lg text-gray-700 my-4">
              I am a Site Reliability Engineer with a strong passion for problem solving and leadership! I have extensive experience in Linux operating systems and containerization at scale. Let me make an impact in your team and organization today. Please check out my projects and learn more about me below!
            </p>
            <ButtonFilled innerText="Projects" faIcon={faCode} link="https://github.com/ChristianBingman"/>
            <ButtonBorder innerText="About Me" faIcon={faPersonRays} link="https://www.linkedin.com/in/christianbingman/"/>
          </div>
        </div>

        {/* Right Section with Image */}
        <div className="flex-1 flex items-center justify-center">
          <div>
            <RoundedImage src="https://avatars.githubusercontent.com/u/42191425?v=4" alt="GitHub Avatar" />
          </div>
        </div>
      </div>
    </div>
  );
}

export default App;
