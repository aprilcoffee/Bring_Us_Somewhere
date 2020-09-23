//Shader PostFix
import ch.bildspur.postfx.builder.*;
import ch.bildspur.postfx.pass.*;
import ch.bildspur.postfx.*;
PostFX fx;

void shaderInit(){
  fx = new PostFX(this);
  frameRate(30);
  smooth(8);
  hint(DISABLE_DEPTH_TEST);
}
