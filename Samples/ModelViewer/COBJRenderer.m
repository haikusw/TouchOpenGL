//
//  COBJRenderer.m
//  ModelViewer
//
//  Created by Jonathan Wight on 03/16/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "COBJRenderer.h"

#import "CVertexBuffer.h"
#import "CVertexBufferReference.h"
#import "CLibrary.h"
#import "CProgram.h"
#import "UIColor_OpenGLExtensions.h"
#import "CMeshLoader.h"
#import "CMesh.h"
#import "CTexture.h"
#import "CImageTextureLoader.h"
#import "CMaterial.h"
#import "CRenderer_Extensions.h"

@interface COBJRenderer ()
@property (readwrite, nonatomic, retain) NSArray *meshes;
@property (readwrite, nonatomic, retain) CProgram *flatProgram;
@property (readwrite, nonatomic, retain) CProgram *textureProgram;
@property (readwrite, nonatomic, retain) CTexture *defaultTexture;
@end

@implementation COBJRenderer

@synthesize meshes;
@synthesize flatProgram;
@synthesize textureProgram;
@synthesize defaultTexture;

- (id)init
	{
	if ((self = [super init]) != NULL)
		{
        CMeshLoader *theLoader = [[[CMeshLoader alloc] init] autorelease];
        self.meshes = [theLoader loadMeshesFromFile:@"Skull"];
        
        self.flatProgram = [[[CProgram alloc] initWithName:@"Flat2"] autorelease];
        self.textureProgram = [[[CProgram alloc] initWithName:@"SimpleTexture"] autorelease];
		}
	return(self);
	}

- (void)render:(Matrix4)inTransform
    {
    AssertOpenGLNoError_();


    const Matrix4 theTransform = Matrix4Scale(inTransform, 0.01, 0.01, 0.01);

    [self drawAxes:theTransform];


    for (CMesh *theMesh in self.meshes)
        {
        Vector3 theCenter = theMesh.center;
        Matrix4 theMeshTransform = Matrix4Concat(Matrix4MakeTranslation(-theCenter.x, -theCenter.y * 1.5, -theCenter.z), theTransform);


        CProgram *theProgram = self.flatProgram;
        
        if (theMesh.material.texture != NULL)
            {
            theProgram = self.textureProgram;
            }

        // Use shader program
        glUseProgram(theProgram.name);
        
        // Update position attribute
        GLuint theVertexAttributeIndex = [theProgram attributeIndexForName:@"a_vertex"];        
        [theMesh.positions use:theVertexAttributeIndex];
        glEnableVertexAttribArray(theVertexAttributeIndex);

        // Update transform uniform
        GLuint theTransformUniformIndex = [theProgram uniformIndexForName:@"u_transform"];
        glUniformMatrix4fv(theTransformUniformIndex, 1, NO, &theMeshTransform.m00);

        if (theProgram == self.textureProgram)
            {
            CTexture *theTexture = theMesh.material.texture;
            
            glBindTexture(GL_TEXTURE_2D, theTexture.name);

            GLuint theTextureAttributeIndex = [theProgram attributeIndexForName:@"a_texture"];        
            [theMesh.texCoords use:theTextureAttributeIndex];
            glEnableVertexAttribArray(theTextureAttributeIndex);
            }
        else
            {
            // Update color uniform
            Color4f theDiffuseColor = theMesh.material.diffuseColor;
            GLuint theDiffuseColorUniformIndex = [theProgram uniformIndexForName:@"u_diffuse_color"];
            glUniform4fv(theDiffuseColorUniformIndex, 1, &theDiffuseColor.r);

            // Update color uniform
            Color4f theAmbientColor = theMesh.material.ambientColor;
            GLuint theAmbientColorUniformIndex = [theProgram uniformIndexForName:@"u_ambient_color"];
            glUniform4fv(theAmbientColorUniformIndex, 1, &theAmbientColor.r);
            }



        // Validate program before drawing. This is a good check, but only really necessary in a debug build. DEBUG macro must be defined in your debug configurations if that's not already the case.
    #if defined(DEBUG)
        NSError *theError = NULL;
        if ([theProgram validate:&theError] == NO)
            {
            NSLog(@"Failed to validate program: %@", theError);
            return;
            }
    #endif
    
        AssertOpenGLNoError_();

        glDrawArrays(GL_TRIANGLES, 0, theMesh.positions.rowCount);
        }
    }


@end