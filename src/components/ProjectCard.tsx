import React from 'react';

// Define the shape of the data this component needs
interface ProjectCardProps {
  title: string;
  description: string;
  technologies: string[];
  link: string;
  demoLink?: string;
}

const ProjectCard: React.FC<ProjectCardProps> = ({title, description, technologies, link, demoLink}) => {
  return (  
    <div className="project-card">
      <h3>{title}</h3>
      <p>{description}</p>
      <div className="tech-stack">
      {technologies.map((tech, index) => (
        <React.Fragment key={tech}>
        <span className="tech-badge">{tech}</span>
        {index !== technologies.length - 1 && " "}
        </React.Fragment>
      ))}
      </div>
      <div className="project-links">
      <a href={link} target="_blank" rel="noopener noreferrer" className="project-link">
        View Project
      </a>
      {demoLink && (
          <a 
            href={demoLink} 
            download="pong_final.s" // Forces download and sets filename
            className="btn-file"
          >
            &nbsp Download Source Code
          </a>
        )}
      </div>
    </div>
  );
};

export default ProjectCard;