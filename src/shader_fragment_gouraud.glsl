#version 330 core

in vec4 vertex_color;

// O valor de saída ("out") de um Fragment Shader é a cor final do fragmento.
out vec4 color;

// Variável para o preview
uniform float u_alpha = 1.0; // Valor padrão é 1.0 (opaco)

// Coordenadas de textura obtidas do arquivo OBJ (se existirem!)
in vec2 texcoords;

// Constantes
#define M_PI   3.14159265358979323846
#define M_PI_2 1.57079632679489661923

uniform sampler2D FloorTexture;
uniform sampler2D SkyboxTexture;
uniform sampler2D WoodTexture;
uniform sampler2D ConcreteTexture;
uniform sampler2D RubberTexture;
uniform sampler2D FireTexture;

uniform int object_id;
#define SKY  0
#define ROCKS  1
#define WOOD  2
#define CONCRETE  3
#define RUBBER  4
#define FIRE  5

void main()
{
    vec3 texColor = vec3(1.0);

    if (object_id == ROCKS)
        texColor = texture(FloorTexture, texcoords).rgb;
    else if (object_id == WOOD)
        texColor = texture(WoodTexture, texcoords).rgb;
    else if (object_id == CONCRETE)
        texColor = texture(ConcreteTexture, texcoords).rgb;
    else if (object_id == RUBBER)
        texColor = texture(RubberTexture, texcoords).rgb;
    else if (object_id == FIRE)
        texColor = texture(FireTexture, texcoords).rgb;
    else if (object_id == SKY)
        texColor = texture(SkyboxTexture, texcoords).rgb;

    vec3 finalColor = texColor * vertex_color.rgb * 2.0; // leve aumento
    finalColor = pow(finalColor, vec3(1.0 / 2.2));        // correção gama

    color = vec4(finalColor, 1.0);
} 

