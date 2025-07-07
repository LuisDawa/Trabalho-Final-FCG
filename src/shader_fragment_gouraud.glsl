#version 330 core

in vec4 vertex_color;

// O valor de saída ("out") de um Fragment Shader é a cor final do fragmento.
out vec4 color;

// Constantes
#define M_PI   3.14159265358979323846
#define M_PI_2 1.57079632679489661923

void main()
{
    vec3 gamma_corrected = pow(vertex_color.rgb, vec3(1.0 / 2.2));
    color = vec4(gamma_corrected, vertex_color.a);
} 

