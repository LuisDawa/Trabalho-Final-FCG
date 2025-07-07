#ifndef COLLISIONS_H
#define COLLISIONS_H

#include <string>
#include <vector>
#include <map>
#include <glm/mat4x4.hpp>
#include <glm/vec3.hpp>
#include <glad/glad.h>

// Estruturas de dados movidas de main.cpp para cá
struct SceneObject
{
    std::string  name;
    size_t       first_index;
    size_t       num_indices;
    GLenum       rendering_mode;
    GLuint       vertex_array_object_id;
    glm::vec3    bbox_min;
    glm::vec3    bbox_max;
};

struct PlacedObject
{
    std::string objectName;
    glm::mat4   modelMatrix;
    bool        isFalling;
    int         textureId;
};

// Estrutura para representar uma AABB no espaço do mundo
struct WorldAABB {
    glm::vec3 min;
    glm::vec3 max;
};


// --- DECLARAÇÃO DAS FUNÇÕES DE COLISÃO ---

// Teste 1 e 2: AABB vs AABB (usado para objeto-objeto e objeto-plano)
WorldAABB GetWorldAABB(const PlacedObject& object, const std::map<std::string, SceneObject>& virtualScene);
bool CheckAABBCollision(const WorldAABB& a, const WorldAABB& b);

// Estrutura para uma esfera de colisão
struct WorldSphere {
    glm::vec3 center;
    float radius;
};

// Declaração das novas funções
WorldSphere GetWorldBoundingSphere(const PlacedObject& object, const std::map<std::string, SceneObject>& virtualScene);
bool CheckSphereSphereCollision(const WorldSphere& a, const WorldSphere& b);
bool CheckAABBSphereCollision(const WorldAABB& aabb, const WorldSphere& sphere);

#endif // COLLISIONS_H