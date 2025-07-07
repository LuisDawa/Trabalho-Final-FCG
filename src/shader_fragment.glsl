#version 330 core

// Atributos de fragmentos recebidos como entrada ("in") pelo Fragment Shader.
in vec4 position_world;
in vec4 normal;

// Posição do vértice atual no sistema de coordenadas local do modelo.
in vec4 position_model;

// Coordenadas de textura obtidas do arquivo OBJ (se existirem!)
in vec2 texcoords;

// Matrizes computadas no código C++ e enviadas para a GPU
uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

// Identificador que define qual objeto está sendo desenhado no momento
#define SKY   0
#define ROCKS 1
// O ID 2 pode ser usado para o cubo de preview ou outros objetos
uniform int object_id;

// Parâmetros da axis-aligned bounding box (AABB) do modelo
uniform vec4 bbox_min;
uniform vec4 bbox_max;

// Variáveis para acesso das imagens de textura
uniform sampler2D SkyboxTexture; // Corresponde à textura unit 0
uniform sampler2D FloorTexture;  // Corresponde à textura unit 1
uniform sampler2D CubeTexture;   // Corresponde à textura unit 2 (para o cubo)

// Variável para o preview
uniform float u_alpha = 1.0; // Valor padrão é 1.0 (opaco)

// O valor de saída ("out") de um Fragment Shader é a cor final do fragmento.
out vec4 final_color;

// Constantes
#define M_PI   3.14159265358979323846
#define M_PI_2 1.57079632679489661923

void main()
{
    vec4 origin = vec4(0.0, 0.0, 0.0, 1.0);
    vec4 camera_position = inverse(view) * origin;

    vec4 p = position_world;
    vec4 n = normalize(normal);
    vec4 l = normalize(vec4(1.0,1.0,0.0,0.0)); // Luz direcional simples
    vec4 v = normalize(camera_position - p);

    vec3 Kd0 = vec3(1.0); // Cor difusa padrão (branco)

    // --- Lógica de Textura ---
    if ( object_id == ROCKS )
    {
        // Multiplica as coordenadas de textura por um fator para repetir a textura (tiling).
        // Altere o valor 50.0 para deixar as pedras maiores ou menores.
        vec2 uv = texcoords * 50.0; 

        // Usa as novas coordenadas "repetidas" para buscar a cor da textura.
        Kd0 = texture(FloorTexture, uv).rgb;
    }
    else if( object_id == SKY )
    {
        // Mapeamento esférico para a skybox
        vec4 bbox_center = (bbox_min + bbox_max) / 2.0;
        vec3 model_position = position_model.xyz - bbox_center.xyz;

        float u = 0.5 + (atan(model_position.z, model_position.x) / (2.0 * M_PI));
        float v = 0.5 - (asin(normalize(model_position).y) / M_PI);

        // A textura da skybox está na unidade 0
        final_color = texture(SkyboxTexture, vec2(u,v));
    }
    else // Para o cubo e outros objetos
    {
       // A textura do cubo está na unidade 2
       Kd0 = texture(CubeTexture, texcoords).rgb;
    }

    // --- Lógica de Iluminação (não se aplica à skybox) ---
    if( object_id != SKY )
    {
        float lambert = max(0, dot(n, l));
        final_color.rgb = Kd0 * (lambert + 0.15); // Adicionei um pouco de luz ambiente
    }

    // Aplica correção de gamma para um resultado visual melhor
    final_color.rgb = pow(final_color.rgb, vec3(1.0/2.2));

    // Aplica a transparência para o objeto de preview
    final_color.a = u_alpha;
}