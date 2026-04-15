import React from 'react';

// Define the shape of the data this component needs
interface ProjectCardProps {
  title: string;
  description: string;
  technologies: string[];
  link: string;
}

const ProjectCard: React.FC<ProjectCardProps> = ({title, description, technologies, link}) => {
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
      <a href={link} target="_blank" rel="noopener noreferrer" className="project-link">
        View Project
      </a>
    </div>
  );
};

export default ProjectCard;