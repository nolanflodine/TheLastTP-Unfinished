PImage Person;
PImage SLeftU;
PImage SRightU;
PImage SLeftD;
PImage SRightD;
PImage Start;
PImage Instructions;
PImage Winner;
PImage refill;
PImage snail;
PImage Spray;
PImage Infected2;
PImage Drop2;
String State = "Start";
int next = 1;
PImage tape;
float Infectedx = random(10, 440);
boolean hide1 = false;
boolean rainOn = false;
float SanitizerX = 200;
int SanitizerY = 60;
float DropX = SanitizerX;
float DropY = 60;
ArrayList<Drops> drops = new ArrayList<Drops>();
ArrayList<Infected> Infected = new ArrayList<Infected>();
ArrayList<PowerUp> PowerUp = new ArrayList<PowerUp>();
int Capacity = 20;
long wait = 0;
long wait2 = 0;
long wait3 = 0;
long wait4 = 0;
long wait5 = 0;
int time = 1000;
int px = 220;
float Side = int(random(1, 3));
float pyr = random(300, 750);
int pux1 = -100;
int pux2 = 500;
int disinfected = 0;
int randPower = int(random(0, 3));
String img = "";
int Timer = 0;
int test = 0;
Lysol[] lysol = new Lysol[500];

void setup() {
  size(500, 800);
  background(165, 115, 75);
  wait = millis();
  Person = loadImage("Person.png");
  refill = loadImage("Refill.png");
  tape = loadImage("CautionTape.jpg");
  Start = loadImage("StartPage.png");
  Instructions = loadImage("Instructions.png");
  Winner = loadImage("Weener.png");
  snail = loadImage("SnailPower.png");
  Spray = loadImage("Spray.png");
  Infected2 = loadImage("Infected1.png");
  Drop2 = loadImage("WaterDrop.png");
  Drop2.resize(20, 40);
  Infected2.resize(30, 60);
  Person.resize(60, 120);
  tape.resize(500, 25);
  for (int i = 0; i < lysol.length; i++) { 
    lysol[i] = new Lysol();
  }
}


void draw() {
  checkState();
  if (State.equals("Start")) {
    image(Start, 0, 0);
  }
  if (State.equals("Instructions")) {
    image(Instructions, 0, 0);
  }
  if (State.equals("Winner")) {
    for (int i = 0; i<Infected.size(); i++) {
      Infected.get(i).x = 9999;
    }
    background(165, 115, 75);
    image(Winner, 0, 0);
    textSize(40);
    fill(25,25,255);
    text("You won in " + Timer + " seconds!", 13, 775);
    noLoop();
  }
  if (State.equals("Loser")) {
    shake();
    if (millis() - wait>3000) { 
      background(165, 115, 75);
      noLoop();
      PImage Infected;
      Infected = loadImage("Infected1.png");
      Infected.resize(60, 120);
      image(Infected, 220, 50);
      wait = millis();
      textSize(60);
      fill(255, 0, 0);
      text("You Got Infected", 10, 400);
    }
  }
  if (State.equals("Game")) {
    //System.out.println(rainOn);
    background(165, 115, 75);
    image(tape, 0, 200);
    image(Person, px, 50);
    image(Infected2, 400, 5);
    image(Drop2, 15, 15);
    InfectedSpawn();
    PowerUpSpawn();
    HandSanitizer();
    SanitizerFollow();
    Projectile();
    levelCheck();
    sprayCheck();
    Timer();
    textSize(35);
    text(Capacity, 50, 50);
    text(disinfected, 450, 50);
    text("S:" + Timer, 400, 100);
    for (int i = 0; i<PowerUp.size(); i++) {
      PowerUp.get(i).draw();
      if (PowerUp.get(i).x>500||PowerUp.get(i).x<-100) {
        PowerUp.get(i).y = 9999;
      }
    }
    for (int i = 0; i<Infected.size(); i++) {
      Infected.get(i).draw();
      Infected.get(i).attack();
      Infected.get(i).infect();
      if (Infected.get(i).y<=200 && Infected.get(i).y>=50) {
        Capacity=0;
      }
    }
    for (int i = 0; i<drops.size(); i++) {
      drops.get(i).draw();
      drops.get(i).goDown();
      drops.get(i).Collision();
    }
    if (rainOn==true) {
      for (int i = 0; i < lysol.length; i++) {
        lysol[i].fall(); 
        lysol[i].show();
        lysol[i].Collision();
      }
    }
  }
}

void Timer() {
  if (millis() -wait4>1000) {
    Timer++;
    wait4 = millis();
  }
}
void HandSanitizer() {
  SLeftU = loadImage("SanitizerLeftUp.png");
  SRightU = loadImage("SanitizerRightUp.png");
  SLeftD = loadImage("SanitizerLeftDown.png");
  SRightD = loadImage("SanitizerRightDown.png");
  SLeftU.resize(56, 75);
  SRightU.resize(56, 75);
  SLeftD.resize(56, 65);
  SRightD.resize(58, 66);
  if (SanitizerX<225&&hide1==false) {
    image(SLeftU, SanitizerX, SanitizerY);
  }
  if (SanitizerX>=225&&hide1==false) {
    image(SRightU, SanitizerX, SanitizerY);
  }
  if (SanitizerX<225&&mousePressed==true) {
    image(SLeftU, -1000, -1000);
    image(SLeftD, SanitizerX, SanitizerY+10);
    hide1 = true;
  }
  if (SanitizerX>=225&&mousePressed==true) {
    image(SRightU, -1000, -1000);
    image(SRightD, SanitizerX-1, SanitizerY+9);
    hide1 = true;
  }
  if (mousePressed==false) {
    hide1 = false;
  }
}
void shake() {
  for (int i = 0; i<99; i++) {
    if (px<250) {
      px=px+50;
    }
  }
  background(165, 115, 75);
  image(Person, px, 50);
  if (px>200) {
    px=px-60;
  }
  background(165, 115, 75);
  image(Person, px, 50);
}

void SanitizerFollow() {
  if (SanitizerX>mouseX-28&&SanitizerX>=0) {
    SanitizerX=SanitizerX-20;
  }
  if (SanitizerX<mouseX-28&&SanitizerX>=0) {
    SanitizerX=SanitizerX+20;
  }
  if (SanitizerX<0) {
    SanitizerX=SanitizerX+20;
  }
  if (SanitizerX>444) {
    SanitizerX=SanitizerX-20;
  }
}

void Projectile() {
  if (mousePressed&&Capacity>0) {
    if (millis() - wait>150) {
      Capacity--;
      drops.add(new Drops ((int)SanitizerX, 60, 30, 60));
      wait = millis();
    }
  }
}
void sprayCheck() {
  System.out.println(test);
  if (rainOn==true) {
    //System.out.println(rainOn);
    if (Timer>=test+5) {
      rainOn = false;
      wait5 = millis();
    }
  }
}
void levelCheck() {
  if (disinfected==25) {
    time = 750;
  }
  if (disinfected==50) {
    time = 500;
  }
  if (disinfected==75) {
    time = 250;
  }
}

void InfectedSpawn() {
  if (millis() - wait>time) {
    Infected.add(new Infected ((int)Infectedx, 800, 60, 120));
    Infectedx = random(10, 440);
    wait = millis();
  }
}

void PowerUpSpawn() {
  if (millis() - wait2>10000) {
    if (pux1>=500||pux1<=-100&&pux2>=500||pux2<=-100) {
      Side = int(random(1, 3));
    }
    pyr = random(300, 750);
    img = "";
    if (Side==1.0) {
      PowerUp.add(new PowerUp(refill, pux1, (int)pyr, 75, 75));
    }
    if (Side==2.0) {
      PowerUp.add(new PowerUp(refill, pux2, (int)pyr, 75, 75));
    }
    wait2 = millis();
  }
  if (millis() - wait3>17000) {
    if (randPower==1) {
      img = "snail";
      pyr = random(300, 750);
      if (Side==1.0) {
        PowerUp.add(new PowerUp(snail, pux1, (int)pyr, 50, 50));
      }
      if (Side==2.0) {
        PowerUp.add(new PowerUp(snail, pux2, (int)pyr, 50, 50));
      }
    }
    if (randPower==2) {
      img = "Spray";
      pyr = random(300, 750);
      if (Side==1.0) {
        PowerUp.add(new PowerUp(Spray, pux1, (int)pyr, 50, 50));
      }
      if (Side==2.0) {
        PowerUp.add(new PowerUp(Spray, pux2, (int)pyr, 50, 50));
      }
    }
    wait3 = millis();
  }
  randPower = int(random(0, 3));
}

void checkState() {
  if (key == ' ') {
    State = "Instructions";
  }
  if (key==ENTER) {
    State = "Game";
  }
  if (disinfected==100||key=='w') {
    State = "Winner";
  }
  for (int i = 0; i<Infected.size(); i++) {
    if (Infected.get(i).y==50) {
      State = "Loser";
    }
  }
}
public class PowerUp {
  int x;
  int y;
  int width;
  int height;
  PImage p;
  public PowerUp(PImage p, int x, int y, int width, int height) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    this.p = p;
    p.resize(width, height);
  }
  void draw() {
    if (pux1>500) {
      pux1 = -100;
      img = "";
    }
    if (pux2<-100) {
      pux2 = 500;
      img = "";
    }
    if (Side==1.0) {
      x = x+4;
    }
    if (Side==2.0) {
      x = x-4;
    }
    image(p, x, y);
  }
}

public class Lysol {
  float LX;
  float LY;
  float LZ;
  float len;
  float yspeed;
  Lysol() {
    LX = random(width);
    LY = random(-500, -50);
    LZ = random(0, 20);
    len = map(LZ, 0, 20, 1, 10);
    yspeed = map(LZ, 0, 20, 1, 10);
  }

  void fall() {
    LY = LY + yspeed;
    float grav = map(LZ, 0, 20, 0, 0.2);
    yspeed = yspeed + grav;
    if (LY>height) {
      LY = random(-200, -100);
      yspeed = map(LZ, 0, 20, 1, 10);
    }
  }

  void show() {
    float thick = map(LZ, 0, 20, 2, 4);
    strokeWeight(thick);
    stroke(150, 150, 255);
    line(LX, LY, LX, LY+len);
  }
  void Collision() {
    for (int z = 0; z<lysol.length; z++) {
      for (int i = 0; i<Infected.size(); i++) {
        if (lysol[z].LX>Infected.get(i).x && lysol[z].LX<Infected.get(i).x+60 && lysol[z].LY>Infected.get(i).y && lysol[z].LY<Infected.get(i).y+120) {
            Infected.get(i).x=9999;
            Infected.get(i).y = 0;                 
        }
        }
      }
    }
  }

  public class Infected {
    int x;
    int y;
    int width;
    int height;
    PImage Infected;
    public Infected(int x, int y, int width, int height) {
      this.x = x;
      this.y = y;
      this.width = width;
      this.height = height;
      Infected = loadImage("Infected1.png");
      Infected.resize(width, height);
    }
    void attack() {
      if (y>220) {
        y--;
      }
    }
    void infect() {
      if (y<=220) {
        if (y>=50) {
          y--;
        }
        if (x<220) {
          x++;
        }
        if (x>220) {
          x--;
        }
      }
    }

    void draw() {
      image(Infected, x, y);
    }
  }

  public class Drops {
    int x;
    int y;
    int width;
    int height;
    PImage Drop;
    public Drops(int x, int y, int width, int height) {
      this.x = x;
      this.y = y;
      this.width = width;
      this.height = height;
      Drop = loadImage("WaterDrop.png");
      Drop.resize(width, height);
    }
    void goDown() {
      if (y<860) {
        y=y+10;
      }
    }
    void draw() {
      image(Drop, x, y);
    }
    void Collision() {
      for (int z = 0; z<drops.size(); z++) {
        if (drops.get(z).y>860) {
          drops.get(z).x = 999999;
          drops.get(z).y = 999999;
        }
        for (int i = 0; i<Infected.size(); i++) {
          if (drops.get(z).x>Infected.get(i).x-30 && drops.get(z).x<Infected.get(i).x+60 && drops.get(z).y>Infected.get(i).y && drops.get(z).y<Infected.get(i).y+120) {
            drops.get(z).x=999999;
            Infected.get(i).x=9999;
            Infected.get(i).y = 0;
            disinfected++;
          }
        }
      } 
      for (int z = 0; z<drops.size(); z++) {
        for (int i = 0; i<PowerUp.size(); i++) {
          if (drops.get(z).x>PowerUp.get(i).x-30 && drops.get(z).x<PowerUp.get(i).x+100 && drops.get(z).y>PowerUp.get(i).y && drops.get(z).y<PowerUp.get(i).y+100) {
            drops.get(z).x=9999;
            PowerUp.get(i).x = 99999999;
            if (img.equals("snail")) {
              time = time+500;
            }
            if (img.equals("")) {
              Capacity = Capacity+10;
            }
            if (img.equals("Spray")) {
              rainOn = true;
              //System.out.println(rainOn);
              test = Timer;
            }
          }
        }
      }
    }
  }