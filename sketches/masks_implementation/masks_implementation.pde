PImage img;
PGraphics original;
PGraphics mask;
int matrixsize = 3;
boolean inv = false;

float[][] matrix = { { 0, 0, 0 },
                     { 0, 1, 0 },
                     { 0, 0, 0 } }; 

void setup() {
  size(844, 422);
  img = loadImage("/sketches/masks_implementation/lena.jpg"); 
  original = createGraphics(422, 422);
  mask = createGraphics(422, 422);
  noStroke();
}

void draw() {
  original.beginDraw();
  original.image(img,0,0);
  original.endDraw();
  mask.beginDraw();
  mask.image(img,0,0); 
  mask.loadPixels();
  for (int y = 0; y < mask.height; y++) {
    for (int x = 0; x < mask.width; x++ ) {
      color c = convolution(x, y, matrix, matrixsize, mask);
      int loc = x + y*mask.width;
      mask.pixels[loc] = c;
    }
  }
  mask.updatePixels()
  mask.endDraw();
  image(original, 0, 0);
  image(mask, 422, 0);
}

void keyPressed(){
  // Edge detection
  matrixsize = 3;
  if(key == 'a'){
    matrix = { { -1, -1, -1 },
               { -1,  8, -1 },
               { -1, -1, -1 } }; 
  }else if(key == 'b'){
    matrix = { { -1, 0,  1 },
               { -2, 0,  2 },
               { -1, 0,  1 } };
  }
  // Blur
  else if (key == 'c') {
    matrix = { { 1/9, 1/9, 1/9 },
               { 1/9, 1/9, 1/9 },
               { 1/9, 1/9, 1/9 } };
  }else if (key == 'd'){
    matrixsize = 5;
    matrix = {{1 / 256, 4  / 256,  6 / 256,  4 / 256, 1 / 256},
                   {4 / 256, 16 / 256, 24 / 256, 16 / 256, 4 / 256},
                   {6 / 256, 24 / 256, 36 / 256, 24 / 256, 6 / 256},
                   {4 / 256, 16 / 256, 24 / 256, 16 / 256, 4 / 256},
                   {1 / 256, 4  / 256,  6 / 256,  4 / 256, 1 / 256}}
  }
  // Sharpering
  else if (key == 'e') {
    matrix = { { -2, -1,  0 },
               { -1,  1,  1 },
               {  0,  1,  2} };
  }
  // Emboss
  else if (key == 'f') {
    matrix = {{ 0  , -1 ,   0 },
              {-1 ,   5  , -1 },
              { 0  , -1 ,  0 }};
  }
  // Sobel operators
  else if (key == 'g') {
    matrix = {{-1 ,-2 ,-1 },
              { 0 , 0 , 0 },
              { 1 , 2 , 1 }};
  }else if (key == 'h') {
    matrix = {{ 1 , 0 ,-1 },
              { 2 , 0 ,-2 },
              { 1 , 0 ,-1 }};
  }else if (key == 'i') {
    matrix = {{-1 , 0 , 1 },
              {-2 , 0 , 2 },
              {-1 , 0 , 1 }};
  }else if (key == 'j') {
    matrix = {{ 1 , 2 , 1 },
              { 0 , 0 , 0 },
              {-1 ,-2 ,-1 }};
  }else if (key == 'k') {
    inv = !inv;
  }
  // Normal
  else if (key == 'l') {
    matrix = { { 0, 0, 0 },
               { 0, 1, 0 },
               { 0, 0, 0 } }; 
    inv = false;
  }
}

color convolution(int x, int y, float[][] matrix, int matrixsize, PGraphics mask){
  float rtotal = 0.0;
  float gtotal = 0.0;
  float btotal = 0.0;
  for (int i = 0; i < matrixsize; i++){
    for (int j= 0; j < matrixsize; j++){
      int xloc = x+i;
      int yloc = y+j;
      int loc = xloc + mask.width*yloc;
      loc = constrain(loc,0,mask.pixels.length-1);
      rtotal += (red(mask.pixels[loc]) * matrix[i][j]);
      gtotal += (green(mask.pixels[loc]) * matrix[i][j]);
      btotal += (blue(mask.pixels[loc]) * matrix[i][j]);
    }
  }
  rtotal = constrain(rtotal, 0, 255);
  gtotal = constrain(gtotal, 0, 255);
  btotal = constrain(btotal, 0, 255);
  if(!inv){
      return color(rtotal, gtotal, btotal);
    }else{
      return color(255-rtotal, 255-gtotal, 255-btotal)
    }
}
