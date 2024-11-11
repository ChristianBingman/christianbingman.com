import React from 'react';
import PropTypes from 'prop-types';

const ImageComponent = ({ src, alt }) => {
  return (
    <img 
      src={src} 
      alt={alt} 
      className="rounded-full md:rounded-[100px] w-full h-auto object-contain" 
    />
  );
};

ImageComponent.propTypes = {
  src: PropTypes.string.isRequired,
  alt: PropTypes.string.isRequired,
};

export default ImageComponent;
