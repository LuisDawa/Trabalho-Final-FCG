#version 330 core

// Atributos de vértice recebidos como entrada ("in") pelo Vertex Shader.
// Veja a função BuildTrianglesAndAddToVirtualScene() em "main.cpp".
layout (location = 0) in vec4 model_coefficients;
layout (location = 1) in vec4 normal_coefficients;
layout (location = 2) in vec2 texture_coefficients;

// Matrizes computadas no código C++ e enviadas para a GPU
uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;
uniform vec3 light_pos;
uniform vec3 view_pos;
uniform int object_id;

#define SKY  0
#define ROCKS  1
#define WOOD  2
#define CONCRETE  3

// Saída para o fragment shader
out vec4 vertex_color;

void main()
{
    gl_Position = projection * view * model * model_coefficients;

    vec3 p = vec3(model * model_coefficients); // posição do vértice no mundo
    vec3 n = normalize(mat3(transpose(inverse(model))) * vec3(normal_coefficients));
    vec3 l = normalize(light_pos - p);
    vec3 v = normalize(view_pos - p);
    vec3 h = normalize(l + v); // vetor halfway (Blinn)

    vec3 Kd, Ka, Ks;
    float q;

    if (object_id == ROCKS) { // ROCKS
        Kd = vec3(0.8, 0.8, 0.8);
        Ka = 0.2 * Kd;
        Ks = vec3(0.3);
        q = 32.0;
    } else if (object_id == WOOD) { // WOOD
        Kd = vec3(0.6, 0.3, 0.1);
        Ka = 0.2 * Kd;
        Ks = vec3(0.2);
        q = 16.0;
    } else if (object_id == CONCRETE) { // WOOD
        Kd = vec3(0.6, 0.3, 0.1);
        Ka = 0.2 * Kd;
        Ks = vec3(0.2);
        q = 16.0;
    } else {
        Kd = vec3(0.5);
        Ka = 0.2 * Kd;
        Ks = vec3(0.2);
        q = 16.0;
    }

    vec3 I = vec3(1.0);      // intensidade da luz
    vec3 Ia = vec3(0.2);     // luz ambiente

    float n_dot_l = max(dot(n, l), 0.0);
    float n_dot_h = max(dot(n, h), 0.0);

    vec3 ambient = Ia * Ka;
    vec3 diffuse = I * Kd * n_dot_l;
    vec3 specular = I * Ks * pow(n_dot_h, q);

    vertex_color = vec4(ambient + diffuse + specular, 1.0);
}

