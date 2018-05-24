#version 430 core

layout(triangles, equal_spacing, ccw, point_mode) in;

layout(binding = 0, rgba8) uniform image3D voxelColor;
layout(binding = 1, rgba8) uniform image3D voxelNormal;

layout(binding = 0) uniform sampler2D diffuseMap;

in vec4 tcPosition[];
in vec3 tcNormal[];
in vec2 tcTexcoord[];

out TE_OUT {
    vec3 worldPosition;
    vec3 normal;
    vec2 texcoord;
    vec4 voxelColor;
} te_out;

uniform mat4 projection;
uniform mat4 view;

uniform float voxelDim = 256;
uniform vec3 voxelMin = vec3(-20), voxelMax = vec3(20), voxelCenter = vec3(0);

void main() {
    vec4 position = gl_TessCoord.x * tcPosition[0]
                    + gl_TessCoord.y * tcPosition[1]
                    + gl_TessCoord.z * tcPosition[2];
    vec3 normal = gl_TessCoord.x * tcNormal[0]
                    + gl_TessCoord.y * tcNormal[1]
                    + gl_TessCoord.z * tcNormal[2];
    vec2 texcoord = gl_TessCoord.x * tcTexcoord[0]
                    + gl_TessCoord.y * tcTexcoord[1]
                    + gl_TessCoord.z * tcTexcoord[2];

    vec4 color = texture(diffuseMap, texcoord);
    vec3 voxelPosition = (position.xyz - voxelCenter - voxelMin) / (voxelMax - voxelMin);
    ivec3 voxelIndex = ivec3(voxelPosition * imageSize(voxelColor).xyz);
    imageStore(voxelColor, voxelIndex, color);
    imageStore(voxelNormal, voxelIndex, vec4(normalize(normal) * 0.5 + 0.5, 1));

    te_out.worldPosition = position.xyz;
    te_out.normal = normal;
    te_out.texcoord = texcoord;
    te_out.voxelColor = color;

    // if (gl_TessLevelInner[0] > 32.0) te_out.voxelColor = vec4(1, 0, 0, 1);
    // if (gl_TessLevelInner[0] > 48.0) te_out.voxelColor = vec4(0, 1, 0, 1);
    // if (gl_TessLevelInner[0] >= 64.0) te_out.voxelColor = vec4(0, 0, 1, 1);
    // TODO fill adjacent voxels if tess level >= some threshold?


    // gl_Position = position;
    gl_Position = projection * view * position;
}