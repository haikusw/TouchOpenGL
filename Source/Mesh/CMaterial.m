//
//  CMaterial.m
//  TouchOpenGL
//
//  Created by Jonathan Wight on 03/17/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are
//  permitted provided that the following conditions are met:
//
//     1. Redistributions of source code must retain the above copyright notice, this list of
//        conditions and the following disclaimer.
//
//     2. Redistributions in binary form must reproduce the above copyright notice, this list
//        of conditions and the following disclaimer in the documentation and/or other materials
//        provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY JONATHAN WIGHT ``AS IS'' AND ANY EXPRESS OR IMPLIED
//  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
//  FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL JONATHAN WIGHT OR
//  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//  ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
//  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
//  ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//  The views and conclusions contained in the software and documentation are those of the
//  authors and should not be interpreted as representing official policies, either expressed
//  or implied, of toxicsoftware.com.

#import "CMaterial.h"

#import "COpenGLAssetLibrary.h"
#import "CTexture.h"

@interface CMaterial ()
@property (readwrite, nonatomic, retain) NSString *name;
@property (readwrite, nonatomic, assign) Color4f ambientColor;
@property (readwrite, nonatomic, assign) Color4f diffuseColor;
@property (readwrite, nonatomic, assign) Color4f specularColor;
@property (readwrite, nonatomic, assign) GLfloat shininess;
@property (readwrite, nonatomic, assign) GLfloat alpha;

@property (readwrite, nonatomic, retain) CTexture *texture;
@end

@implementation CMaterial

@synthesize name;
@synthesize ambientColor;
@synthesize diffuseColor;
@synthesize specularColor;
@synthesize shininess;
@synthesize alpha;
@synthesize texture;

- (id)init
	{
	if ((self = [super init]) != NULL)
		{
        const GLfloat kRGB = 1.0;
        
        ambientColor = (Color4f){ kRGB, kRGB, kRGB, 1.0 };
        diffuseColor = (Color4f){ kRGB, kRGB, kRGB, 1.0 };
        specularColor = (Color4f){ kRGB, kRGB, kRGB, 1.0 };
        shininess = 1.0;
        alpha = 1.0;
		}
	return(self);
	}

- (void)dealloc
    {
    [name release];
    name = NULL;
    
    [texture release];
    texture = NULL;
    //
    [super dealloc];
    }

- (NSString *)description
    {
    return([NSString stringWithFormat:@"%@ (%@)", [super description], self.name]);
    }

- (id)copyWithZone:(NSZone *)zone;
    {
    #pragma unused (zone)
    
    CMaterial *theCopy = [[CMaterial alloc] init];
    theCopy.name = self.name;
    theCopy.ambientColor = self.ambientColor;
    theCopy.diffuseColor = self.diffuseColor;
    theCopy.specularColor = self.specularColor;
    theCopy.shininess = self.shininess;
    theCopy.alpha = self.alpha;
    return(theCopy);
    }

@end

#pragma mark -

@implementation CMutableMaterial

@dynamic name;
@dynamic ambientColor;
@dynamic diffuseColor;
@dynamic specularColor;
@dynamic shininess;
@dynamic alpha;
@dynamic texture;

- (id)mutableCopyWithZone:(NSZone *)zone;
    {
    #pragma unused (zone)
    
    CMutableMaterial *theCopy = [[CMutableMaterial alloc] init];
    theCopy.name = self.name;
    theCopy.ambientColor = self.ambientColor;
    theCopy.diffuseColor = self.diffuseColor;
    theCopy.specularColor = self.specularColor;
    theCopy.shininess = self.shininess;
    theCopy.alpha = self.alpha;
    return(theCopy);
    }


@end
