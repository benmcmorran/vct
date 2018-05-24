#version 430 core

layout(triangles, equal_spacing, ccw) in;

layout(binding = 0, rgba8) uniform image3D voxels;

in vec4 tcPosition[];
in vec3 tcNormal[];
in vec2 tcTexcoord[];

out vec3 fragPosition;
out vec3 fragNormal;
out vec2 fragTexcoord;

uniform mat4 projection;
uniform mat4 view;

void main() {
    vec4 position = gl_TessCoord.x * tcPosition[0]//gl_in[0].gl_Position;
                + gl_TessCoord.y * tcPosition[1]//gl_in[1].gl_Position;
                + gl_TessCoord.z * tcPosition[2];//gl_in[2].gl_Position;
    gl_Position = projection * view * position;

    fragPosition = position.xyz;
    fragNormal = gl_TessCoord.x * tcNormal[0]
                + gl_TessCoord.y * tcNormal[1]
                + gl_TessCoord.z * tcNormal[2];
    fragTexcoord = gl_TessCoord.x * tcTexcoord[0]
                + gl_TessCoord.y * tcTexcoord[1]
                + gl_TessCoord.z * tcTexcoord[2];

    // imageStore(voxels, ivec3(0), vec4(1,0,1,1));
}