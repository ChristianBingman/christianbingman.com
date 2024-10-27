import React from 'react';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

const ButtonBorder = ({ link, innerText, faIcon }) => {
  return (
    <div className="border-[6px] border-[#86AFBF] inline mx-4 p-2 px-3 rounded-lg">
      <a href={link} className="font-bold text-xl text-[#86AFBF]">{ innerText } <FontAwesomeIcon icon={faIcon} /></a>
    </div>
  );
};

export default ButtonBorder;
