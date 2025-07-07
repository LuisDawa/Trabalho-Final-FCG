#define NOMINMAX
#include "collisions.h"
#include <glm/gtc/matrix_transform.hpp> // Para glm::min, glm::max
#include <glm/geometric.hpp> // Para glm::distance

// Converte a AABB local de um objeto para uma AABB no espaço do mundo
// NOTA: Modificamos a função para receber a cena virtual como parâmetro, em vez de usar uma variável global.
WorldAABB GetWorldAABB(const PlacedObject& object, const std::map<std::string, SceneObject>& virtualScene)
{
    const SceneObject& sceneObj = virtualScene.at(object.objectName);
    glm::vec3 local_min = sceneObj.bbox_min;
    glm::vec3 local_max = sceneObj.bbox_max;

    glm::vec3 corners[8] = {
        glm::vec3(local_min.x, local_min.y, local_min.z),
        glm::vec3(local_max.x, local_min.y, local_min.z),
        glm::vec3(local_min.x, local_max.y, local_min.z),
        glm::vec3(local_min.x, local_min.y, local_max.z),
        glm::vec3(local_max.x, local_max.y, local_min.z),
        glm::vec3(local_min.x, local_max.y, local_max.z),
        glm::vec3(local_max.x, local_min.y, local_max.z),
        glm::vec3(local_max.x, local_max.y, local_max.z)
    };

    WorldAABB world_aabb;
    world_aabb.min = world_aabb.max = glm::vec3(object.modelMatrix * glm::vec4(corners[0], 1.0f));

    for (int i = 1; i < 8; ++i) {
        glm::vec3 transformed_corner = glm::vec3(object.modelMatrix * glm::vec4(corners[i], 1.0f));
        world_aabb.min = glm::min(world_aabb.min, transformed_corner);
        world_aabb.max = glm::max(world_aabb.max, transformed_corner);
    }

    return world_aabb;
}

// Verifica se duas AABBs (a e b) estão colidindo
bool CheckAABBCollision(const WorldAABB& a, const WorldAABB& b)
{
    return (a.min.x <= b.max.x && a.max.x >= b.min.x) &&
           (a.min.y <= b.max.y && a.max.y >= b.min.y) &&
           (a.min.z <= b.max.z && a.max.z >= b.min.z);
}

// Calcula uma esfera de colisão que envolve o objeto
WorldSphere GetWorldBoundingSphere(const PlacedObject& object, const std::map<std::string, SceneObject>& virtualScene)
{
    // Primeiro, obtemos a AABB do objeto no espaço do mundo
    WorldAABB world_aabb = GetWorldAABB(object, virtualScene);

    // O centro da esfera será o centro da AABB
    glm::vec3 center = (world_aabb.min + world_aabb.max) / 2.0f;

    // O raio será metade da diagonal da AABB
    float radius = glm::distance(world_aabb.min, world_aabb.max) / 2.0f;

    return WorldSphere{center, radius};
}

// Verifica se duas esferas (a e b) estão colidindo
bool CheckSphereSphereCollision(const WorldSphere& a, const WorldSphere& b)
{
    // Calcula a distância entre os centros das duas esferas
    float distance_between_centers = glm::distance(a.center, b.center);

    // Calcula a soma dos raios
    float sum_of_radii = a.radius + b.radius;

    // Se a distância for menor que a soma dos raios, elas estão colidindo
    return distance_between_centers < sum_of_radii;
}

bool CheckAABBSphereCollision(const WorldAABB& aabb, const WorldSphere& sphere)
{
    // Encontra o ponto 'p' na AABB que está mais próximo do centro da esfera.
    float closest_x = std::max(aabb.min.x, std::min(sphere.center.x, aabb.max.x));
    float closest_y = std::max(aabb.min.y, std::min(sphere.center.y, aabb.max.y));
    float closest_z = std::max(aabb.min.z, std::min(sphere.center.z, aabb.max.z));

    glm::vec3 closest_point(closest_x, closest_y, closest_z);

    // **CORREÇÃO AQUI**
    // Calcula o vetor de diferença entre o ponto mais próximo e o centro da esfera.
    glm::vec3 diff_vector = closest_point - sphere.center;

    // Calcula a distância ao quadrado usando o comprimento ao quadrado (length2) do vetor de diferença.
    float distance_squared = glm::length(diff_vector);
    float radius_squared = sphere.radius * sphere.radius;

    // Se a distância ao quadrado for menor que o raio ao quadrado, há uma colisão.
    return distance_squared < radius_squared;
}