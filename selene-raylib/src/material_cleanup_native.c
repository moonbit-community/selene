#include <moonbit.h>
#include <string.h>

#define SELENE_RAYLIB_MAX_MATERIAL_MAPS 12

typedef struct {
  unsigned int id;
  int width;
  int height;
  int mipmaps;
  int format;
} SeleneRaylibTexturePrefix;

typedef struct {
  unsigned char r;
  unsigned char g;
  unsigned char b;
  unsigned char a;
} SeleneRaylibColorPrefix;

typedef struct {
  SeleneRaylibTexturePrefix texture;
  SeleneRaylibColorPrefix color;
  float value;
} SeleneRaylibMaterialMapPrefix;

typedef struct {
  unsigned int id;
  int *locs;
} SeleneRaylibShaderPrefix;

typedef struct {
  SeleneRaylibShaderPrefix shader;
  SeleneRaylibMaterialMapPrefix *maps;
  float params[4];
} SeleneRaylibMaterialPrefix;

typedef struct {
  SeleneRaylibMaterialPrefix material;
  int freed;
  void *parent;
} SeleneRaylibMaterialWrapperPrefix;

MOONBIT_FFI_EXPORT
void
selene_raylib_reset_material_from_material(
  SeleneRaylibMaterialWrapperPrefix *target,
  SeleneRaylibMaterialWrapperPrefix *source
) {
  if (target == NULL || source == NULL) return;

  target->material.shader = source->material.shader;
  memcpy(
    target->material.params, source->material.params, sizeof(target->material.params)
  );

  if (target->material.maps != NULL && source->material.maps != NULL) {
    memcpy(
      target->material.maps,
      source->material.maps,
      sizeof(SeleneRaylibMaterialMapPrefix) * SELENE_RAYLIB_MAX_MATERIAL_MAPS
    );
  }
}
