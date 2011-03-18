//
//  CMeshLoader.m
//  ModelViewer
//
//  Created by Jonathan Wight on 03/17/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CMeshLoader.h"

#import "OpenGLIncludes.h"

#import "CTexture.h"
#import "CImageTextureLoader.h"
#import "CMesh.h"
#import "CVertexBuffer.h"
#import "CVertexBufferReference.h"
#import "OpenGLTypes.h"
#import "CMaterial.h"

@implementation CMeshLoader

- (NSArray *)loadMeshesFromFile:(NSString *)inName;
    {
    NSURL *theURL = [[NSBundle mainBundle] URLForResource:inName withExtension:@"model.plist"];
    NSDictionary *theDictionary = [NSDictionary dictionaryWithContentsOfURL:theURL];

    // Load materials.
    NSDictionary *theMaterialsDictionary = [theDictionary objectForKey:@"materials"];
    NSMutableDictionary *theMaterials = [NSMutableDictionary dictionary];
    
    for (NSString *theMaterialName in theMaterialsDictionary)
        {
        NSDictionary *theMaterialDictionary = [theMaterialsDictionary objectForKey:theMaterialName];
        
        CMaterial *theMaterial = [[[CMaterial alloc] init] autorelease];
        theMaterial.name = theMaterialName;
        
        if ([theMaterialDictionary objectForKey:@"ambientColor"] != NULL)
            {
            NSArray *theComponents = [theMaterialDictionary objectForKey:@"ambientColor"];
            theMaterial.ambientColor = (Color4f){
                [[theComponents objectAtIndex:0] floatValue],
                [[theComponents objectAtIndex:1] floatValue],
                [[theComponents objectAtIndex:2] floatValue],
                1.0};
            }

        if ([theMaterialDictionary objectForKey:@"diffuseColor"] != NULL)
            {
            NSArray *theComponents = [theMaterialDictionary objectForKey:@"diffuseColor"];
            theMaterial.diffuseColor = (Color4f){
                [[theComponents objectAtIndex:0] floatValue],
                [[theComponents objectAtIndex:1] floatValue],
                [[theComponents objectAtIndex:2] floatValue],
                1.0};
            }

        if ([theMaterialDictionary objectForKey:@"specularColor"] != NULL)
            {
            NSArray *theComponents = [theMaterialDictionary objectForKey:@"specularColor"];
            theMaterial.specularColor = (Color4f){
                [[theComponents objectAtIndex:0] floatValue],
                [[theComponents objectAtIndex:1] floatValue],
                [[theComponents objectAtIndex:2] floatValue],
                1.0};
            }
        
        
        NSString *theTextureName = [theMaterialDictionary objectForKey:@"texture"];
        if (theTextureName.length > 0)
            {        
            NSError *theError = NULL;
            CTexture *theTexture = [[CImageTextureLoader textureLoader] textureWithImageNamed:theTextureName error:&theError];
            theMaterial.texture = theTexture;
            }

        [theMaterials setObject:theMaterial forKey:theMaterialName];
        }

    NSMutableArray *theMeshes = [NSMutableArray array];

    // Load meshs.
    NSArray *theMeshDictionaries = [theDictionary objectForKey:@"meshes"];
    for (NSDictionary *theMeshDictionary in theMeshDictionaries)
        {
        NSString *theMaterialName = [theMeshDictionary objectForKey:@"material"];
        
        NSArray *theVBONames = [theMeshDictionary objectForKey:@"VBOs"];
		for (NSString *theVBOName in theVBONames)
			{
			CMesh *theMesh = [[[CMesh alloc] init] autorelease];
			theMesh.material = [theMaterials objectForKey:theMaterialName];

			NSURL *theURL = [[NSBundle mainBundle] URLForResource:theVBOName withExtension:@"vbo"];
			NSData *theData = [NSData dataWithContentsOfURL:theURL];
			
			NSLog(@"%d", theData.length);

			size_t theRowSize = sizeof(Vector3) + sizeof(Vector2) + sizeof(Vector3);
			size_t theRowCount = theData.length / theRowSize;

			CVertexBuffer *theVertexBuffer = [[[CVertexBuffer alloc] initWithTarget:GL_ARRAY_BUFFER usage:GL_STATIC_DRAW data:theData] autorelease];

			GLint theStride = theRowSize;

			theMesh.positions = [[[CVertexBufferReference alloc] initWithVertexBuffer:theVertexBuffer rowSize:theRowSize rowCount:theRowCount size:3 type:GL_FLOAT normalized:NO stride:theStride offset:0] autorelease];
			theMesh.texCoords = [[[CVertexBufferReference alloc] initWithVertexBuffer:theVertexBuffer rowSize:theRowSize rowCount:theRowCount size:2 type:GL_FLOAT normalized:NO stride:theStride offset:sizeof(Vector3)] autorelease];
			
			[theMeshes addObject:theMesh];
			}
		}
    
	NSLog(@"%@", theMeshes);
	
    return(theMeshes); 
    }

@end
