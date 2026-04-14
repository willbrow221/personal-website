import React from 'react';
import './Hero.css';

interface HeroProps {
  name: string;
  role: string;
  tagline: string;
}

const Hero: React.FC<HeroProps> = ({ name, role, tagline }) => {
  return (
    <section className="hero">
      <div className="hero-content">
        <p className="hero-greeting">Hi, my name is</p>
        <h1 className="hero-name">{name}</h1>
        <h2 className="hero-role">{role}</h2>
        <p className="hero-tagline">{tagline}</p>
        <div className="hero-cta">
          <a href="#projects" className="btn-primary">View My Work</a>
          <a href="/resume.pdf" className="btn-secondary" target="_blank">Resume</a>
        </div>
      </div>
    </section>
  );
};

export default Hero;