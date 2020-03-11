// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: YLMessageModel.proto

// This CPP symbol can be defined to use imports that match up to the framework
// imports needed when using CocoaPods.
#if !defined(GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS)
 #define GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS 0
#endif

#if GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS
 #import <Protobuf/GPBProtocolBuffers_RuntimeSupport.h>
#else
 #import "GPBProtocolBuffers_RuntimeSupport.h"
#endif

 #import "YlmessageModel.pbobjc.h"
// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#pragma mark - YlmessageModelRoot

@implementation YlmessageModelRoot

// No extensions in the file and no imports, so no need to generate
// +extensionRegistry.

@end

#pragma mark - YlmessageModelRoot_FileDescriptor

static GPBFileDescriptor *YlmessageModelRoot_FileDescriptor(void) {
  // This is called by +initialize so there is no need to worry
  // about thread safety of the singleton.
  static GPBFileDescriptor *descriptor = NULL;
  if (!descriptor) {
    GPB_DEBUG_CHECK_RUNTIME_VERSIONS();
    descriptor = [[GPBFileDescriptor alloc] initWithPackage:@""
                                                     syntax:GPBFileSyntaxProto3];
  }
  return descriptor;
}

#pragma mark - YLUserModel

@implementation YLUserModel

@dynamic userId;
@dynamic name;
@dynamic avatar;

typedef struct YLUserModel__storage_ {
  uint32_t _has_storage_[1];
  NSString *userId;
  NSString *name;
  NSString *avatar;
} YLUserModel__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "userId",
        .dataTypeSpecific.className = NULL,
        .number = YLUserModel_FieldNumber_UserId,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(YLUserModel__storage_, userId),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "name",
        .dataTypeSpecific.className = NULL,
        .number = YLUserModel_FieldNumber_Name,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(YLUserModel__storage_, name),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "avatar",
        .dataTypeSpecific.className = NULL,
        .number = YLUserModel_FieldNumber_Avatar,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(YLUserModel__storage_, avatar),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[YLUserModel class]
                                     rootClass:[YlmessageModelRoot class]
                                          file:YlmessageModelRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(YLUserModel__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\001\001\006\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - YLMessageModel

@implementation YLMessageModel

@dynamic hasFromUser, fromUser;
@dynamic hasToUser, toUser;
@dynamic messageType;
@dynamic textString;
@dynamic messageSource;
@dynamic voiceLength;
@dynamic voiceData;
@dynamic token;
@dynamic messageId;

typedef struct YLMessageModel__storage_ {
  uint32_t _has_storage_[1];
  uint32_t messageType;
  uint32_t voiceLength;
  YLUserModel *fromUser;
  YLUserModel *toUser;
  NSString *textString;
  NSString *messageSource;
  NSData *voiceData;
  NSString *token;
  NSString *messageId;
} YLMessageModel__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "fromUser",
        .dataTypeSpecific.className = GPBStringifySymbol(YLUserModel),
        .number = YLMessageModel_FieldNumber_FromUser,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(YLMessageModel__storage_, fromUser),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeMessage,
      },
      {
        .name = "toUser",
        .dataTypeSpecific.className = GPBStringifySymbol(YLUserModel),
        .number = YLMessageModel_FieldNumber_ToUser,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(YLMessageModel__storage_, toUser),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeMessage,
      },
      {
        .name = "messageType",
        .dataTypeSpecific.className = NULL,
        .number = YLMessageModel_FieldNumber_MessageType,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(YLMessageModel__storage_, messageType),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeUInt32,
      },
      {
        .name = "textString",
        .dataTypeSpecific.className = NULL,
        .number = YLMessageModel_FieldNumber_TextString,
        .hasIndex = 3,
        .offset = (uint32_t)offsetof(YLMessageModel__storage_, textString),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "messageSource",
        .dataTypeSpecific.className = NULL,
        .number = YLMessageModel_FieldNumber_MessageSource,
        .hasIndex = 4,
        .offset = (uint32_t)offsetof(YLMessageModel__storage_, messageSource),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "voiceLength",
        .dataTypeSpecific.className = NULL,
        .number = YLMessageModel_FieldNumber_VoiceLength,
        .hasIndex = 5,
        .offset = (uint32_t)offsetof(YLMessageModel__storage_, voiceLength),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeUInt32,
      },
      {
        .name = "voiceData",
        .dataTypeSpecific.className = NULL,
        .number = YLMessageModel_FieldNumber_VoiceData,
        .hasIndex = 6,
        .offset = (uint32_t)offsetof(YLMessageModel__storage_, voiceData),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeBytes,
      },
      {
        .name = "token",
        .dataTypeSpecific.className = NULL,
        .number = YLMessageModel_FieldNumber_Token,
        .hasIndex = 7,
        .offset = (uint32_t)offsetof(YLMessageModel__storage_, token),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "messageId",
        .dataTypeSpecific.className = NULL,
        .number = YLMessageModel_FieldNumber_MessageId,
        .hasIndex = 8,
        .offset = (uint32_t)offsetof(YLMessageModel__storage_, messageId),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[YLMessageModel class]
                                     rootClass:[YlmessageModelRoot class]
                                          file:YlmessageModelRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(YLMessageModel__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\010\001\010\000\002\006\000\003\013\000\004\n\000\005\r\000\006\013\000\007\t\000\t\t\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end


#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)
