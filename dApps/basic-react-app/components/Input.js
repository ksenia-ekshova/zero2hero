import { useState } from "react";

function Input() {
  const [name, setName] = useState("");

  function handleOnChange(text) {
    setName(text);
  }

  return (
    <>
      <input type="text" onChange={(e) => handleOnChange(e.target.value)} />
      <p>Hello, {name}!</p>
    </>
  );
}

export default Input;
