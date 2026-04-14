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
    title: "RytAid: Electronic Health System for Elderly Care",
    description: "Collaborated with a team to build a medicinal storage and reminder system for an elderly client. \n Independently designed and implemented a system which opens the box with an electrical motor and sends text message reminders to take medications.\n",
    technologies: ["Arduino", "HTTP", "Analog Circuit Design"],
    link: "https://sites.google.com/u.northwestern.edu/rytaid/home?authuser=2"
  },
];