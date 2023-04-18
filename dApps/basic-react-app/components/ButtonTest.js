import styles from "@/styles/Home.module.css";
import { useState } from "react";

function ButtonTest() {
  const [number, setNumber] = useState(0);
  //let number = 0;
  function increment() {
    //number++;
    setNumber(number + 1);
    console.log("Button was clicked");
  }

  return (
    <>
      <p>{number}</p>
      <button className={styles.button} onClick={increment}>
        Increment
      </button>
    </>
  );
}

export default ButtonTest;
