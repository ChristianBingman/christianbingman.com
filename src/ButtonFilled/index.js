import React from 'react';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

const ButtonFilled = ({ link, innerText, faIcon }) => {
  return (
    <div className="bg-[#86AFBF] inline py-3 px-5 rounded-lg shadow-[0_4px_12px_-3px_rgba(41,113,141,1)]">
      <a href={link} className="font-bold text-xl ">{ innerText } <FontAwesomeIcon icon={faIcon} /></a>
    </div>
  );
};

export default ButtonFilled;
