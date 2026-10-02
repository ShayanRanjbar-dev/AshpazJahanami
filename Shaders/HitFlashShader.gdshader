shader_type canvas_item;

uniform float flashValue : hint_range(0.0, 1.0, 0.1);
uniform vec4 flashColor : source_color = vec4(1,1,1,1);

void fragment(){
	vec4 inputTexture = texture(TEXTURE,UV);
	vec4 outputTexture =  mix(inputTexture , flashColor , flashValue) ;
	COLOR  = vec4(vec3(outputTexture.r,outputTexture.g,outputTexture.b) , inputTexture.a);
	}