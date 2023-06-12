import React from 'react';
import clsx from 'clsx';
import Link from '@docusaurus/Link';
import useDocusaurusContext from '@docusaurus/useDocusaurusContext';
import Layout from '@theme/Layout';
import { useColorMode } from '@docusaurus/theme-common';

import styles from './index.module.css';

function HomepageHeader() {
  const { siteConfig } = useDocusaurusContext();
  const { colorMode } = useColorMode();
  return (
    <header className={clsx('hero', styles.heroBanner)}>
      <div className="container">
        <img
          className={clsx(styles.heroLogo)}
          src={
            colorMode == 'dark'
              ? 'img/workflows_logo_dark.svg'
              : 'img/workflows_logo.svg'
          }
          alt="Very Good Workflows Logo"
        />
        <p className="hero__subtitle">{siteConfig.tagline}</p>
        <HomepageHeroImage />
        <HomepageCTA />
      </div>
    </header>
  );
}

export default function Home(): JSX.Element {
  const { siteConfig } = useDocusaurusContext();
  return (
    <Layout
      description={`The official documentation site for Very Good Workflows. ${siteConfig.tagline}`}
    >
      <HomepageHeader />
      <main>
        <HomepageBlogs />
      </main>
    </Layout>
  );
}

function HomepageCTA() {
  return (
    <div className={styles.width}>
      <Link className="button button--primary button--lg" to="/docs/overview">
        Get Started &gt;
      </Link>
    </div>
  );
}

function HomepageHeroImage() {
  const { colorMode } = useColorMode();
  return (
    <img
      className={clsx(styles.heroImage)}
      src="img/workflows_hero.png"
      alt="Hero"
      width="720"
    />
  );
}

function HomepageBlogs() {
  return (
    <div className={`${styles.section}`}>
      <div className={styles.width}>
        <div className={styles.column}>
          <img
            style={{ height: 'auto' }}
            src="https://uploads-ssl.webflow.com/5ee12d8e99cde2e20255c16c/61ef1d505cfdeb570f714a7f_Very%20good%20workflows.jpg"
            alt="Configuring workflows for your Flutter projects"
            width="452"
            height="254"
          />
        </div>
        <div className={styles.column}>
          <div className={styles.content}>
            <h2>Configuring workflows for your Flutter projects</h2>
            <p>A guide for using Very Good Workflows in your projects.</p>
            <Link
              style={{ fontWeight: 'bold' }}
              to="https://verygood.ventures/blog/configuring-workflows-for-your-flutter-projects"
            >
              Read the Blog &gt;
            </Link>
          </div>
        </div>
      </div>
      <div style={{ padding: '1rem' }}></div>
    </div>
  );
}
