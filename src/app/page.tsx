"use client";

import Image from "next/image";
import { useEffect, useState } from "react";
import styles from "./page.module.css";

import { Connect } from "@stacks/connect-react";

import ConnectWallet, { userSession } from "../components/ConnectWallet";
import ContractCallVote from "../components/ContractCallVote";
import LazyYoutube from "@/components/LazyYoutube";



export default function Home() {
  const [isClient, setIsClient] = useState(false);

  useEffect(() => {
    setIsClient(true);
  }, []);

  if (!isClient) return null;

  return (
    <Connect
      authOptions={{
        appDetails: {
          name: "Stacks Next.js Template",
          icon: window.location.origin + "/logo.png",
        },
        redirectTo: "/",
        onFinish: () => {
          window.location.reload();
        },
        userSession,
      }}
    >
      <main className={styles.main}>
        <div className={styles.description}>
          <p>
            Debank on Stacks
          </p>
          <div>
          <p>
            Use your NFTs as collateral to secure loans on the bitcoin layer2
          </p>
          </div>
        </div>

        <div className={styles.center}>
          <h2>DeBank on Stacks 🏦</h2>

          <LazyYoutube videoId={"_7GBtvhHg3c"} />
          {/* ConnectWallet file: `./src/components/ConnectWallet.js` */}


          {/* ContractCallVote file: `./src/components/ContractCallVote.js` */}
          {/* <ContractCallVote /> */}
        </div>

        <div className={styles.grid}>
          <br />
 
          <ConnectWallet />
        </div>
      </main>
    </Connect>
  );
}
