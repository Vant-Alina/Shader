 //<>//


PGraphics buf1, buf2;//the current state and the state from the previous frame, one is for drawing, one is for storage
PImage cooling_map;
float ystart = 0;
float col_incrm =0;
float col_b = 0;
float col_g = 0;
int w = 700, h = 450;



void setup(){
size(1200, 500);
buf1 = createGraphics(w, height);
buf2 = createGraphics(w, height);
cooling_map= createImage(w, height, RGB);//color palette and shape palette
frameRate(160);


}

//void gradationFading();
//void cool();





void draw(){

background(0);

buf2.beginDraw();//pixels from the pr frame
buf1.beginDraw();////the frame before
buf1.loadPixels();
buf2.loadPixels();

//if (keyPressed == true){
  cool();//noise and brightness, "vertex" shader
  gradationFading();// "Fragment" shader



  
  buf2.updatePixels();
  buf2.endDraw();
  
  PGraphics tmp = buf1;//swap buffers, and redraw 
  buf1 = buf2;
  buf2 = tmp;
  image(buf2,0,0);
 image(cooling_map, w,0);

 
 buf1.endDraw();
}
   // if (mousePressed == true){
        //  buf1.fill(233);

   // buf1.noStroke();
  //  buf1.ellipse(mouseX, mouseY, 50, 50);

//}
//}


void cool(){
  cooling_map.loadPixels();
  float xoff = 0.0; 
  float increment = .02; //noise grain
  
  // noise and brightness
  for (int x = 0; x < w; x++) {//start from the bottom
    xoff += increment;   // increment width (x) 
    float yoff = ystart;   // 
    
  for (int y = 0; y < h; y++) {
      yoff += increment; // Increment yoff

     float n = noise(xoff, yoff); //gen noise  
     
        //if (col_incrm > 255) //to freeze noise on the screen
         //{
           //col_incrm -=4;
            // n = 0;
          //}
         
      float bright = pow(n, 3) * col_incrm;// second screen, current state of cooling map
      
     cooling_map.pixels[x+y*w] = color(0, 0,  (bright));
       
   } 
         
  }
   col_incrm+= 2;//makes pic more bright

  cooling_map.updatePixels();
  ystart += increment;//scroll bottom pixels
 
}




void gradationFading(){
  
  for (int x= 1; x < w-1; x++){
  for (int y= 1; y < h-1; y++){
    
      int coord_loc1 = (x+1)+y*w;//get the color of pixel
      int coord_loc2 = (x-1)+y*w;//location of 4 neighbour pix
      int coord_loc3 = (x)+(1+y)*w;
      int coord_loc4 = (x)+(y-1)*w;
    color pix1=  buf1.pixels[coord_loc1];
    color pix2=  buf1.pixels[coord_loc2];
    color pix3=  buf1.pixels[coord_loc3];
    color pix4=  buf1.pixels[coord_loc4];
    
      int coord_loc = x+y*w;
      color pix5=  cooling_map.pixels[coord_loc];//get the pixel-sample from c_m
      
   //make it evaporate or cool
    //set the drawing buf to the current state buffer, using c_m
   float grad = (brightness(pix1)+brightness(pix2)+brightness(pix3)+brightness(pix4))/4;//gradation
          grad -= brightness(pix5)*.9;//The flames are then cooled by subtracting a small amount from each pixel, 0.9 just to slow down 
   
      buf2.pixels[coord_loc4] = color(grad, col_g/grad ,col_b/grad+50);//trasform current pixels state to buf2
      buf2.pixels[coord_loc3] = color(grad, col_g/grad ,col_b/grad+50);
      buf2.pixels[coord_loc2] = color(grad, col_g/grad ,col_b/grad+50);
      buf2.pixels[coord_loc1] = color(grad, col_g/grad ,col_b/grad+50);


  }
  
  //check range 0-255
  boolean posDirection = false;//f when brigtens, tr - fades
  if(col_b>=255 && !posDirection){//this is color sparcle effect
posDirection = true;

}else{
if(col_b<=0){//check range 0-255
posDirection = false;
}
if(posDirection){
   col_b-=5.1;
   col_g+=5.1;

  }  
  if(x%2==0 && !posDirection){
  col_b+=5.1;
  col_g-=5.1;
}
}
} 
}












void fire(int rows){//generates "fire" in the bottom
 buf1.beginDraw();
buf1.loadPixels();

for (int x = 0; x < w; x++) {//do the fire calculations for every pixel, from top to bottom
    for (int j = 0; j < rows; j++) {
      int y = h-(j+1);
      int index = x + y * w;
      buf1.pixels[index] = color(#C94733);
    }
  }
  buf1.updatePixels();
  buf1.endDraw();
}
