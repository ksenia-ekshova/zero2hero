import Head from "next/head";
import Image from "next/image";
import { Inter } from "next/font/google";
import styles from "@/styles/Home.module.css";
import ShoppingList from "@/components/ShoppingList";
import Cards from "@/components/Cards";
import ButtonTest from "@/components/ButtonTest";
import Input from "@/components/Input";

const inter = Inter({ subsets: ["latin"] });

export default function Home() {
  return (
    <>
      <main className={styles.main}>
        <div className={styles.description}>
          <p>Learning React</p>
          <div>Turorial 1</div>
        </div>
        <div>
          <p>Compoments: </p>
          <Input />
          <ButtonTest />
          <Cards />
          <ShoppingList />
        </div>
      </main>
    </>
  );
}
