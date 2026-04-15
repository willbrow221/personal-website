export interface Project {
  id: number;
  title: string;
  description: string;
  technologies: string[];
  link: string;
  demoLink?: string;
}

export const projects: Project[] = [
  {
    id: 1,
    title: "Personal Portfolio Website",
    description: "Designed and developed a personal portfolio website to showcase my projects and skills. \n Implemented responsive design principles to ensure optimal viewing across devices, and utilized React for a dynamic user experience.",
    technologies: ["React", "CSS", "JavaScript"],
    link: "https://willbrow221.github.io/personal-website/"
  },
  {
    id: 2,
    title: "RytAid: Electronic Health System for Elderly Care",
    description: "Collaborated with a team to build a medicinal storage and reminder system for an elderly client. \n Independently designed and implemented a system which opens the box with an electrical motor and sends text message reminders to take medications.\n",
    technologies: ["Arduino", "HTTP", "Analog Circuit Design"],
    link: "https://sites.google.com/u.northwestern.edu/rytaid/home?authuser=2"
  },
  {
    id: 3,
    title: "Video Game: Pong Clone",
    description: "Created a simple Pong clone Using ARM assmbly language. \n Implemented game mechanics, including ball movement, paddle control, and collision detection, to create an engaging gaming experience.",
    technologies: ["ARM Assembly", "Game Development", "Low-Level Programming"],
    link: "https://cpulator.01xz.net/?sys=arm-de1soc&d_audio=48000",
    demoLink: "public/pong_final.s"
  },
  
];