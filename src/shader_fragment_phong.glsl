#version 330 core

// Atributos de fragmentos recebidos como entrada ("in") pelo Fragment Shader.
// Neste exemplo, este atributo foi gerado pelo rasterizador como a
// interpolação da posição global e a normal de cada vértice, definidas em
// "shader_vertex.glsl" e "main.cpp".
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
#define SKY  0
#define ROCKS  1
#define WOOD  2
#define CONCRETE  3
#define RUBBER  4
#define FIRE  5
uniform int object_id;

// Parâmetros da axis-aligned bounding box (AABB) do modelo
uniform vec4 bbox_min;
uniform vec4 bbox_max;

// Variáveis para acesso das imagens de textura
uniform sampler2D FloorTexture;
uniform sampler2D SkyboxTexture;
uniform sampler2D WoodTexture;
uniform sampler2D ConcreteTexture;
uniform sampler2D RubberTexture;
uniform sampler2D FireTexture;

// O valor de saída ("out") de um Fragment Shader é a cor final do fragmento.
out vec4 color;

// Constantes
#define M_PI   3.14159265358979323846
#define M_PI_2 1.57079632679489661923

void main()
{
    vec4 origin = vec4(0.0, 0.0, 0.0, 1.0);
    vec4 camera_position = inverse(view) * origin;

    vec4 p = position_world;    
    vec4 n = normalize(normal);
    vec4 l = normalize(camera_position - p);
    vec4 v = normalize(camera_position - p);

    float U = 0.0;
    float V = 0.0;
    vec3 Kd0 = vec3(0.0);

    vec4 h = normalize(l + v); // Vetor que define o sentido da reflexão especular ideal.
    vec3 Kd; // Refletância difusa
    vec3 Ks; // Refletância especular
    vec3 Ka; // Refletância ambiente
    float q; // Expoente especular para o modelo de iluminação de Phong

    if ( object_id == ROCKS )
    {
        U = texcoords.x;
        V = texcoords.y;           

        Kd = texture(FloorTexture, vec2(U,V)).rgb;    
    }
    if ( object_id == WOOD )
    {
        U = texcoords.x;
        V = texcoords.y;           

        Kd = texture(WoodTexture, vec2(U,V)).rgb;    
    }
    if ( object_id == CONCRETE )
    {
        U = texcoords.x;
        V = texcoords.y;           

        Kd = texture(ConcreteTexture, vec2(U,V)).rgb;    
    }
    if ( object_id == RUBBER )
    {
        vec4 bbox_center = (bbox_min + bbox_max) / 2.0;

        vec3 model_position = position_model.xyz - bbox_center.xyz;
        U = 0.5 + (atan(model_position.z, model_position.x) / (2.0 * M_PI));
        V = 0.5 - (asin(model_position.y / length(model_position)) / M_PI);
        V = 1 - V;        

        Kd = texture(RubberTexture, vec2(U,V)).rgb;    
    }
    if ( object_id == FIRE )
    {
        vec4 bbox_center = (bbox_min + bbox_max) / 2.0;

        vec3 model_position = position_model.xyz - bbox_center.xyz;
        U = 0.5 + (atan(model_position.z, model_position.x) / (2.0 * M_PI));
        V = 0.5 - (asin(model_position.y / length(model_position)) / M_PI);
        V = 1 - V;     

        Kd = texture(FireTexture, vec2(U,V)).rgb;    
    }
    else if( object_id == SKY )
    {
        vec4 bbox_center = (bbox_min + bbox_max) / 2.0;

        vec3 model_position = position_model.xyz - bbox_center.xyz;
        U = 0.5 + (atan(model_position.z, model_position.x) / (2.0 * M_PI));
        V = 0.5 - (asin(model_position.y / length(model_position)) / M_PI);
        V = 1 - V;
   
        color.rgb = texture(SkyboxTexture, vec2(U,V)).rgb;                                    
    }
        
    if( object_id != SKY ){  // Objetos que devem ter sobreamento
        vec3 I = vec3(1.0, 1.0, 1.0);

        vec3 Ia = vec3(0.2, 0.2, 0.2);

        float n_dot_l = max(dot(n, l), 0.0);
        vec3 lambert_diffuse_term = I * Kd * n_dot_l;

        vec3 ambient_term = Ia * Ka;

        float n_dot_h = max(dot(n, h), 0.0);
        vec3 blinn_specular_term = I * Ks * pow(n_dot_h, q);
        color.rgb = lambert_diffuse_term + ambient_term + blinn_specular_term;

        color.a = 1;
        color.rgb = pow(color.rgb, vec3(1.0,1.0,1.0)/2.2);
    }


} 

