import Hero from './components/Hero';
import { projects } from './data/projects';
import ProjectCard from './components/ProjectCard';
import './App.css';

function App() {
  return (
    <main>
      <Hero 
        name="Will Brower" 
        role="Computer Software and Hardware Engineer" 
        tagline="Passionate about building innovative solutions and exploring the intersection of software and hardware."
      />
      <div className="portfolio-container">
      <h1>My Projects</h1>
      <div className="project-grid">
        {projects.map((project) => (
          <ProjectCard 
            key={project.id}
            title={project.title}
            description={project.description}
            technologies={project.technologies}
            link={project.link}
          />
        ))}
      </div>
    </div>
    </main>
  );
}

export default App;