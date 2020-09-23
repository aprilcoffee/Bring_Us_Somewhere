//Shader PostFix
import ch.bildspur.postfx.builder.*;
import ch.bildspur.postfx.pass.*;
import ch.bildspur.postfx.*;
PostFX fx;

//easing sequence
import de.looksgood.ani.*;


void shaderInit() {
  //shader setup
  fx = new PostFX(this);
  frameRate(30);


  //Animation setup
  Ani.init(this);


  smooth(8);
  //hint(DISABLE_DEPTH_TEST);
}
