
import processing.video.*;
Movie myMovie;
Movie myMovie2;
int videoScale = 5;
int cols, rows;
float pointillize = 2;
int movX;
int movY;

void setup() {
  size(640, 400);
  myMovie = new Movie(this, "bloom.mp4");
  //myMovie2 = new Movie
  myMovie.loop();
  frameRate(30);
  myMovie.speed(2.0); 

  movX = myMovie.width;
  movY = myMovie.height;
}


void movieEvent(Movie m) {
  m.read();
}


void draw() {
  videoScale = (frameCount % 20) + 5;
  background(0);
  //image(myMovie, 0, 0, cols, rows);

  myMovie.loadPixels();

  if (myMovie.available()) {
    myMovie.read();
  }

  //videoScale = int(random(10));
  //videoScale = frameCount % 10;
  scrubIndicator();
  //image(myMovie, 0, 0);
  //movieScrubber();

  //adjustBrightness();
  drawGrid();
  //drawGridBrightness();
  //pointilize();
}

void pointilize() {
  // Pick a random point
  //int x = int(random(myMovie.width));
  //int y = int(random(myMovie.height));
  for (int x = 0; x < myMovie.width; x++) {
    for (int y = 0; y < myMovie.height; y++) {
      int loc = x + y*myMovie.width;
      // Look up the RGB color in the source image

      float r = red(myMovie.pixels[loc]);
      float g = green(myMovie.pixels[loc]);
      float b = blue(myMovie.pixels[loc]);
      noStroke();
      // Draw an ellipse at that location with that color
      fill(r, g, b);
      ellipse(random(x), y, pointillize, pointillize); // Back to shapes! Instead of setting a pixel, we use the color from a pixel to draw a circle.
    }
  }
}

void drawGrid() {
  // Begin loop for columns
  for (int i = 0; i < movX; i +=videoScale) {
    // Begin loop for rows
    for (int j = 0; j < movY; j +=videoScale) {

      // Looking up the appropriate color in the pixel array
      int loc = i + j * myMovie.width;
      color c = myMovie.pixels[loc];
      fill(c);
      stroke(0);
      ellipse(i, j, videoScale, videoScale);
    }
  }
}

void drawGridBrightness() {
  // Begin loop for columns
  for (int i = 0; i < movX; i +=8) {
    // Begin loop for rows
    for (int j = 0; j < movY; j +=8) {

      // Reversing x to mirror the image
      // In order to mirror the image, the column is reversed with the following formula:
      // mirrored column = width - column - 1
      int loc = (myMovie.width - i - 1) + j*myMovie.width;

      // Each rect is colored white with a size determined by brightness
      color c = myMovie.pixels[loc];

      // A rectangle size is calculated as a function of the pixel's brightness. 
      // A bright pixel is a large rectangle, and a dark pixel is a small one.
      float sz = (brightness(c)/255)*videoScale; 
      rectMode(CENTER);
      fill(255);
      noStroke();
      rect(i + videoScale/2, j + videoScale/2, sz, sz);
    }
  }
}
void adjustBrightness() {
  loadPixels();
  for (int x = 0; x < myMovie.width; x++) {
    for (int y = 0; y < myMovie.height; y++) {

      // Calculate the 1D location from a 2D grid
      int loc = x + y * myMovie.width;

      // Get the R,G,B values from image
      float r = red(myMovie.pixels[loc]);
      float g = green(myMovie.pixels[loc]);
      float b = blue(myMovie.pixels[loc]);

      //calc multiplier ranging 0.0-8.0 based on mouseX pos
      float adjustBrightness = ((float) mouseX / myMovie.width) * 4.0;

      // Calculate an amount to change brightness based on proximity to the mouse
      //float d = dist(x, y, mouseX, mouseY);
      //float adjustBrightness = map(d, 0, 100, 4, 0); //the closer to mouse (0) the brighter
      r *= adjustBrightness;
      g *= adjustBrightness;
      b *= adjustBrightness;

      // Constrain RGB to make sure they are within 0-255 color range
      r = constrain(r, 0, 255);
      g = constrain(g, 0, 255);
      b = constrain(b, 0, 255);

      // Make a new color and set pixel in the window
      color c = color(r, g, b);
      pixels[loc] = c; //pixels not myMovie.pixels
    }
  }
  updatePixels();
}

void scrubIndicator() {
  float jumpPoint = myMovie.time()/myMovie.duration();
  fill(200, 0, 50);
  noStroke();
  ellipse(jumpPoint * width, 380, 20, 20);
}

void movieScrubber() {
  float mousePosRatio = mouseX/ (float)width;
  myMovie.jump(mousePosRatio* myMovie.duration());
  println(mousePosRatio* myMovie.duration());
}
void mousePressed() {

  float mousePosRatio = mouseX/ (float)width;
  myMovie.jump(mousePosRatio* myMovie.duration());
  println((float)mousePosRatio * myMovie.duration());
}