export interface Project {
  id: number;
  title: string;
  description: string;
  technologies: string[];
  link: string;
}

export const projects: Project[] = [
  {
    id: 1,
    title: "E-commerce App",
    description: "Built with React and TypeScript.",
    technologies: ["HTML", "CSS", "TypeScript"],
    link: "https://github.com/youruser/repo"
  },
];