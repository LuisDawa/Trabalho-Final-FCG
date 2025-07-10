# Trabalho Final: INF01047 - Fundamentos De Computação Gráfica

Este projeto é a implementação de um MVP de uma aplicação interativa em OpenGL com C++17 que simula um ambiente de construção em 3D. O usuário pode navegar pelo cenário, selecionar diferentes objetos e posicioná-los no mundo. Os objetos interagem entre si através de um sistema de física simples com detecção de colisão e gravidade.

## Imagens da Aplicação

Aqui estão algumas capturas de tela demonstrando o funcionamento da aplicação:

<inserir imagens>

## Contribuições dos Membros

  * **Jean Argoud:** Foi responsável pela implementação do desenho de todos os objetos e texturas dos mesmos, os tipos de câmera, as transformações dos objetos, os modelos de iluminação, os modelos de interpolação (assim como a troca entre eles) e o algoritmo de curva de Bézier.
  * **Luís Antônio Mikhail Dawa:** Responsável pela implementação da física (queda e colisões) e do preview e do posicionamento de objetos.

## Uso de Ferramentas de IA

Para o desenvolvimento deste trabalho, fizemos uso do ChatGPT e do Gemini. As LLMs foram muito úteis para ajuda em questões pontuais durante o desenvolvimento, como debuggar o código e apontar sugestões de melhorias, especialmente em erros que acontecem no shader, pois nem sempre são eficientes fazendo tarefas muito grandes e complexas de uma vez só. Uma parte do código que foi 100% copiada de IA foi o arquivo shader_vertex_gouraud.glsl e shader_fragment_gouraud.glsl, onde pedimos para ela gerar o código baseada na nossa implementação já existente do modelo de phong.

## Descrição do Desenvolvimento e Conceitos Utilizados

O desenvolvimento da aplicação foi baseado nos conceitos estudados na disciplina de Fundamentos de Computação Gráfica (principalmente nos laboratórios), utilizando C++ e as bibliotecas OpenGL, GLAD, GLFW, e GLM. Abaixo estão os principais conceitos aplicados:

  * **Modelagem e Renderização:**

      * Os modelos 3D (cubo, parede, mesa, etc.) foram carregados a partir de arquivos no formato `.obj` utilizando a biblioteca `tiny_obj_loader`.
      * A renderização é feita através de um pipeline gráfico moderno com Vertex e Fragment Shaders (GLSL). O projeto suporta tanto o modelo de iluminação **Blinn-Phong** e **Lambert**, além de interpolações usando o modelo de **Gouraud** e **Phong**, sendo possível alternar entre eles em tempo de execução.
      * Utilizamos o **Z-buffer** para o correto tratamento de profundidade e o **Backface Culling** para otimizar a renderização, descartando polígonos que não estão virados para a câmera.

  * **Câmera e Projeção:**

      * O sistema de câmera suporta dois modos: uma **câmera livre** (Free Camera) no estilo FPS, que permite ao usuário voar pelo cenário, e uma **câmera orbital** que gira em torno da origem.
      * A aplicação utiliza uma matriz de **projeção perspectiva** para dar a sensação de profundidade, mas também possui a opção de alternar para uma projeção ortográfica.

  * **Texturas e Iluminação:**

      * As texturas são carregadas de arquivos de imagem (`.jpg`) com a biblioteca `stb_image` e mapeadas nos objetos para dar realismo. Cada objeto pode ter uma textura diferente (madeira, concreto, borracha, etc.).
      * O cenário possui um "sol" dinâmico que se move ao longo de uma **curva de Bézier cúbica** dividida em quatro seções, onde o primeiro e último ponto são o mesmo para formar um círculo.

  * **Interação e Física:**

      * O usuário pode selecionar diferentes objetos para construir. Ao posicionar um objeto, ele é adicionado à cena e passa a ser simulado por um sistema de física simples. Os objetos são afetados pela gravidade e caem até colidir com o chão ou com outros objetos.
      * A detecção de colisão é implementada de três formas: entre a **Axis-Aligned Bounding Box (AABB)** de um objeto em queda e a AABB do chão, e entre a AABB do objeto em queda e a **Esfera Envolvente (Bounding Sphere)** dos outros objetos já posicionados.

## Manual de Utilização

### Controles do Mouse:

  * **Movimentar o Mouse:** Controla a direção da câmera (olhar para cima, baixo, esquerda, direita).
  * **Botão Direito (Pressionar e Segurar):** Mostra um *preview* semitransparente do objeto selecionado.
  * **Botão Esquerdo (Clique enquanto segura o Botão Direito):** Posiciona o objeto do *preview* no mundo. O objeto então começa a cair até encontrar uma superfície.

### Controles do Teclado:

  * **W, A, S, D:** Move a câmera para frente, esquerda, trás e direita, respectivamente.
  * **Q / E:** Alterna entre os objetos disponíveis para construção (Cubo, Parede, Piso, Mesa, Bola). O nome do objeto selecionado aparece no canto superior direito da tela.
  * **C:** Alterna entre o modo de câmera livre (*free camera*) e a câmera orbital.
  * **R:** Recarrega os shaders e alterna entre os modelos de iluminação (Phong/Gouraud).
  * **H:** Mostra/Esconde o texto informativo na tela.
  * **ESC:** Fecha a aplicação.

## Compilação e Execução

O projeto espera a seguinte estrutura de diretórios para funcionar corretamente a partir do diretório `build`:

```
seu-projeto/
├── build/          <-- O binário compilado será executado aqui
├── data/           <-- Arquivos .obj, .mtl e texturas (.jpg)
├── src/            <-- Código fonte (.cpp) e shaders (.glsl)
└── include/        <-- Arquivos de cabeçalho (.h)
```

### Passos para Compilação (Linux)


### Passos para Compilação (Windows com Visual Studio)

1) Instale o VSCode seguindo as instruções em https://code.visualstudio.com/ .

2) Instale o compilador GCC no Windows seguindo as instruções em
https://code.visualstudio.com/docs/cpp/config-mingw#_installing-the-mingww64-toolchain .

3) Instale o CMake seguindo as instruções em https://cmake.org/download/ .

4) Instale as extensões "ms-vscode.cpptools" e "ms-vscode.cmake-tools"
no VSCode. Se você abrir o diretório deste projeto no VSCode,
automaticamente será sugerida a instalação destas extensões (pois
estão listadas no arquivo ".vscode/extensions.json").

5) Abra as configurações da extensão cmake-tools (Ctrl-Shift-P e
busque por "CMake: Open CMake Tools Extension Settings"), e adicione o
caminho de instalação do GCC na opção de configuração "additionalCompilerSearchDirs".

6) Compilar: Ctrl-Shift-P e busque por "CMake: Compile Active File"

7) Executar: Ctrl-Shift-P e busque por "CMake: Run Without Debugging" ou "CMake: Debug"
