package;

import openfl.display.Shader;
import openfl.filters.ShaderFilter;
import flixel.system.FlxAssets.FlxShader;
import flixel.*;

class ShadersHandler
{
	public static var chromaticAberration:ShaderFilter = new ShaderFilter(new ChromaticAberration());
	public static var radialBlur:ShaderFilter = new ShaderFilter(new RadialBlur());
	public static var directionalBlur:ShaderFilter = new ShaderFilter(new DirectionalBlur());

	public static function setChrome(chromeOffset:Float):Void
	{
		chromaticAberration.shader.data.rOffset.value = [chromeOffset];
		chromaticAberration.shader.data.gOffset.value = [0.0];
		chromaticAberration.shader.data.bOffset.value = [chromeOffset * -1];
	}
	public static function setRadialBlur(x:Float=640,y:Float=360,power:Float=0.03):Void
	{
		radialBlur.shader.data.blurWidth.value = [power];
		radialBlur.shader.data.cx.value = [x/2560];
		radialBlur.shader.data.cy.value = [y/1440];
	}
	public static function setBlur(angle:Float,power:Float=0.1):Void
	{
		radialBlur.shader.data.angle.value = [angle];
		radialBlur.shader.data.strength.value = [power];
	}
}

class DirectionalBlur extends FlxShader
{
	
	@:glFragmentSource('
	
		#pragma header
			uniform float angle = 90.0;
			uniform float strength = 0.01;
	vec4 color = texture2D(bitmap, openfl_TextureCoordv);
	//looks good @50, can go pretty high tho
			vec2 uv = openfl_TextureCoordv.xy;
			
		const int samples = 20;


		void main()
		{
			
			
			
			float r = radians(angle);
			vec2 direction = vec2(sin(r), cos(r));
			
			
			vec2 ang = strength * direction;
			
			
			vec3 acc = vec3(0);
			
			const float delta = 2.0 / float(samples);
			
			for(float i = -1.0; i <= 1.0; i += delta)
			{
				acc += texture2D(bitmap, uv - vec2(ang.x * i, ang.y * i)).rgb;
			}
			
			
			
			gl_FragColor = vec4(delta * acc, 0);//dirBlur(bitmap, uv, strength*direction);
		}
			
	
	
	')

	public function new() 
	{
		super();
	}
	
}

class RadialBlur extends FlxShader
{

	@:glFragmentSource('
		#pragma header

	uniform float cx = 0.0;
	uniform float cy = 0.0;
    uniform float blurWidth = 10.0;
	
	const int nsamples = 30;
	
	void main(){
		vec4 color = texture2D(bitmap, openfl_TextureCoordv);
			vec2 res;
			res = openfl_TextureCoordv;
		vec2 pp;
		pp = vec2(cx, cy);
		vec2 center = pp.xy /res.xy;
		float blurStart = 1.0;

		
		vec2 uv = openfl_TextureCoordv.xy;
		
		uv -= center;
		float precompute = blurWidth * (1.0 / float(nsamples - 1));
		
		for(int i = 0; i < nsamples; i++)
		{
			float scale = blurStart + (float(i)* precompute);
		color += texture(bitmap, uv * scale + center);
		}
		
		
		color /= float(nsamples);
		
		gl_FragColor = color; 
	
	}')
	public function new()
	{
		super();
		
		
	}
}

class ChromaticAberration extends FlxShader
{
	@:glFragmentSource('
		#pragma header

		uniform float rOffset;
		uniform float gOffset;
		uniform float bOffset;

		void main()
		{
			vec4 col1 = texture2D(bitmap, openfl_TextureCoordv.st - vec2(rOffset, 0.0));
			vec4 col2 = texture2D(bitmap, openfl_TextureCoordv.st - vec2(gOffset, 0.0));
			vec4 col3 = texture2D(bitmap, openfl_TextureCoordv.st - vec2(bOffset, 0.0));
			vec4 toUse = texture2D(bitmap, openfl_TextureCoordv);
			toUse.r = col1.r;
			toUse.g = col2.g;
			toUse.b = col3.b;
			//float someshit = col4.r + col4.g + col4.b;

			gl_FragColor = toUse;
		}')
	public function new()
	{
		super();
	}
}