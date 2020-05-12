PImage Person;
PImage Infected;
float Infectedx = random(60,440);
float Infectedy = random(300,680);

void setup(){
  size(500,800);
  background(165,115,75);
  Person = loadImage("Person.png");
  Infected = loadImage("Infected1.png");
  Person.resize(60,120);
  Infected.resize(60,120);
}

void draw(){
  background(165,115,75);
  image(Person, 220, 50);
  image(Infected, Infectedx, Infectedy);
  attack();
}

void attack(){
  if(Infectedx<220){
    Infectedx++;
  }
  if(Infectedx>220){
    Infectedx--;
  }
  if(Infectedy>150){
    Infectedy--;
  }
}

void HandSanetizer(){
  
}