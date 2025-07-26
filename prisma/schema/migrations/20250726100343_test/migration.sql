-- CreateEnum
CREATE TYPE "ConversationVisibility" AS ENUM ('PRIVATE', 'PUBLIC_LINK', 'PUBLIC_GROUP', 'PUBLIC_DOCUMENT', 'PUBLIC_DATAROOM');

-- CreateEnum
CREATE TYPE "ParticipantRole" AS ENUM ('OWNER', 'PARTICIPANT');

-- CreateEnum
CREATE TYPE "ItemType" AS ENUM ('DATAROOM_DOCUMENT', 'DATAROOM_FOLDER');

-- CreateEnum
CREATE TYPE "DefaultPermissionStrategy" AS ENUM ('INHERIT_FROM_PARENT', 'ASK_EVERY_TIME', 'HIDDEN_BY_DEFAULT');

-- CreateEnum
CREATE TYPE "LinkType" AS ENUM ('DOCUMENT_LINK', 'DATAROOM_LINK');

-- CreateEnum
CREATE TYPE "LinkAudienceType" AS ENUM ('GENERAL', 'GROUP', 'TEAM');

-- CreateEnum
CREATE TYPE "CustomFieldType" AS ENUM ('SHORT_TEXT', 'LONG_TEXT', 'NUMBER', 'PHONE_NUMBER', 'URL', 'CHECKBOX', 'SELECT', 'MULTI_SELECT');

-- CreateEnum
CREATE TYPE "Role" AS ENUM ('ADMIN', 'MANAGER', 'MEMBER');

-- CreateEnum
CREATE TYPE "DocumentStorageType" AS ENUM ('S3_PATH', 'VERCEL_BLOB');

-- CreateEnum
CREATE TYPE "ViewType" AS ENUM ('DOCUMENT_VIEW', 'DATAROOM_VIEW');

-- CreateEnum
CREATE TYPE "EmailType" AS ENUM ('FIRST_DAY_DOMAIN_REMINDER_EMAIL', 'FIRST_DOMAIN_INVALID_EMAIL', 'SECOND_DOMAIN_INVALID_EMAIL', 'FIRST_TRIAL_END_REMINDER_EMAIL', 'FINAL_TRIAL_END_REMINDER_EMAIL');

-- CreateEnum
CREATE TYPE "TagType" AS ENUM ('LINK_TAG', 'DOCUMENT_TAG', 'DATAROOM_TAG');

-- CreateTable
CREATE TABLE "Conversation" (
    "id" TEXT NOT NULL,
    "title" TEXT,
    "isEnabled" BOOLEAN NOT NULL DEFAULT true,
    "visibilityMode" "ConversationVisibility" NOT NULL DEFAULT 'PRIVATE',
    "dataroomId" TEXT NOT NULL,
    "dataroomDocumentId" TEXT,
    "documentVersionNumber" INTEGER,
    "documentPageNumber" INTEGER,
    "linkId" TEXT,
    "viewerGroupId" TEXT,
    "initialViewId" TEXT,
    "teamId" TEXT NOT NULL,
    "lastMessageAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Conversation_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ConversationParticipant" (
    "id" TEXT NOT NULL,
    "conversationId" TEXT NOT NULL,
    "role" "ParticipantRole" NOT NULL DEFAULT 'PARTICIPANT',
    "viewerId" TEXT,
    "userId" TEXT,
    "receiveNotifications" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ConversationParticipant_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Message" (
    "id" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "conversationId" TEXT NOT NULL,
    "userId" TEXT,
    "viewerId" TEXT,
    "viewId" TEXT,
    "isRead" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Message_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ConversationView" (
    "id" TEXT NOT NULL,
    "conversationId" TEXT NOT NULL,
    "viewId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ConversationView_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Dataroom" (
    "id" TEXT NOT NULL,
    "pId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "teamId" TEXT NOT NULL,
    "conversationsEnabled" BOOLEAN NOT NULL DEFAULT false,
    "enableChangeNotifications" BOOLEAN NOT NULL DEFAULT false,
    "defaultPermissionStrategy" "DefaultPermissionStrategy" NOT NULL DEFAULT 'INHERIT_FROM_PARENT',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Dataroom_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DataroomDocument" (
    "id" TEXT NOT NULL,
    "dataroomId" TEXT NOT NULL,
    "documentId" TEXT NOT NULL,
    "folderId" TEXT,
    "orderIndex" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "DataroomDocument_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DataroomFolder" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "path" TEXT NOT NULL,
    "parentId" TEXT,
    "dataroomId" TEXT NOT NULL,
    "orderIndex" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "DataroomFolder_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DataroomBrand" (
    "id" TEXT NOT NULL,
    "logo" TEXT,
    "banner" TEXT,
    "brandColor" TEXT,
    "accentColor" TEXT,
    "dataroomId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "DataroomBrand_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ViewerGroup" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "domains" TEXT[],
    "allowAll" BOOLEAN NOT NULL DEFAULT false,
    "dataroomId" TEXT NOT NULL,
    "teamId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ViewerGroup_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ViewerGroupMembership" (
    "id" TEXT NOT NULL,
    "viewerId" TEXT NOT NULL,
    "groupId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ViewerGroupMembership_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ViewerGroupAccessControls" (
    "id" TEXT NOT NULL,
    "groupId" TEXT NOT NULL,
    "itemId" TEXT NOT NULL,
    "itemType" "ItemType" NOT NULL,
    "canView" BOOLEAN NOT NULL DEFAULT true,
    "canDownload" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ViewerGroupAccessControls_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PermissionGroup" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "dataroomId" TEXT NOT NULL,
    "teamId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "PermissionGroup_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PermissionGroupAccessControls" (
    "id" TEXT NOT NULL,
    "groupId" TEXT NOT NULL,
    "itemId" TEXT NOT NULL,
    "itemType" "ItemType" NOT NULL,
    "canView" BOOLEAN NOT NULL DEFAULT true,
    "canDownload" BOOLEAN NOT NULL DEFAULT false,
    "canDownloadOriginal" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "PermissionGroupAccessControls_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Link" (
    "id" TEXT NOT NULL,
    "documentId" TEXT,
    "dataroomId" TEXT,
    "linkType" "LinkType" NOT NULL DEFAULT 'DOCUMENT_LINK',
    "url" TEXT,
    "name" TEXT,
    "slug" TEXT,
    "expiresAt" TIMESTAMP(3),
    "password" TEXT,
    "allowList" TEXT[],
    "denyList" TEXT[],
    "emailProtected" BOOLEAN NOT NULL DEFAULT true,
    "emailAuthenticated" BOOLEAN NOT NULL DEFAULT false,
    "allowDownload" BOOLEAN DEFAULT false,
    "isArchived" BOOLEAN NOT NULL DEFAULT false,
    "domainId" TEXT,
    "domainSlug" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "enableNotification" BOOLEAN DEFAULT true,
    "enableFeedback" BOOLEAN DEFAULT false,
    "enableQuestion" BOOLEAN DEFAULT false,
    "enableScreenshotProtection" BOOLEAN DEFAULT false,
    "enableAgreement" BOOLEAN DEFAULT false,
    "agreementId" TEXT,
    "showBanner" BOOLEAN DEFAULT false,
    "enableWatermark" BOOLEAN DEFAULT false,
    "watermarkConfig" JSONB,
    "audienceType" "LinkAudienceType" NOT NULL DEFAULT 'GENERAL',
    "groupId" TEXT,
    "permissionGroupId" TEXT,
    "metaTitle" TEXT,
    "metaDescription" TEXT,
    "metaImage" TEXT,
    "metaFavicon" TEXT,
    "enableCustomMetatag" BOOLEAN DEFAULT false,
    "enableConversation" BOOLEAN NOT NULL DEFAULT false,
    "enableUpload" BOOLEAN DEFAULT false,
    "isFileRequestOnly" BOOLEAN DEFAULT false,
    "uploadFolderId" TEXT,
    "enableIndexFile" BOOLEAN DEFAULT false,
    "teamId" TEXT,

    CONSTRAINT "Link_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "LinkPreset" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "teamId" TEXT NOT NULL,
    "pId" TEXT,
    "enableCustomMetaTag" BOOLEAN DEFAULT false,
    "metaTitle" TEXT,
    "metaDescription" TEXT,
    "metaImage" TEXT,
    "metaFavicon" TEXT,
    "enableNotification" BOOLEAN DEFAULT false,
    "emailProtected" BOOLEAN DEFAULT true,
    "emailAuthenticated" BOOLEAN DEFAULT false,
    "allowDownload" BOOLEAN DEFAULT false,
    "enableAllowList" BOOLEAN DEFAULT false,
    "allowList" TEXT[],
    "enableDenyList" BOOLEAN DEFAULT false,
    "denyList" TEXT[],
    "expiresIn" INTEGER,
    "enableScreenshotProtection" BOOLEAN DEFAULT false,
    "expiresAt" TIMESTAMP(3),
    "enablePassword" BOOLEAN DEFAULT false,
    "password" TEXT,
    "enableWatermark" BOOLEAN DEFAULT false,
    "watermarkConfig" JSONB,
    "enableAgreement" BOOLEAN DEFAULT false,
    "agreementId" TEXT,
    "enableCustomFields" BOOLEAN DEFAULT false,
    "customFields" JSONB,
    "isDefault" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "LinkPreset_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CustomField" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "type" "CustomFieldType" NOT NULL,
    "identifier" TEXT NOT NULL,
    "label" TEXT NOT NULL,
    "placeholder" TEXT,
    "required" BOOLEAN NOT NULL DEFAULT false,
    "disabled" BOOLEAN NOT NULL DEFAULT false,
    "linkId" TEXT NOT NULL,
    "orderIndex" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "CustomField_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CustomFieldResponse" (
    "id" TEXT NOT NULL,
    "data" JSONB NOT NULL,
    "viewId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "CustomFieldResponse_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Account" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "provider" TEXT NOT NULL,
    "providerAccountId" TEXT NOT NULL,
    "refresh_token" TEXT,
    "access_token" TEXT,
    "expires_at" INTEGER,
    "token_type" TEXT,
    "scope" TEXT,
    "id_token" TEXT,
    "session_state" TEXT,

    CONSTRAINT "Account_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Session" (
    "id" TEXT NOT NULL,
    "sessionToken" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "expires" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Session_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "User" (
    "id" TEXT NOT NULL,
    "name" TEXT,
    "email" TEXT,
    "emailVerified" TIMESTAMP(3),
    "image" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "contactId" TEXT,
    "plan" TEXT NOT NULL DEFAULT 'free',
    "stripeId" TEXT,
    "subscriptionId" TEXT,
    "startsAt" TIMESTAMP(3),
    "endsAt" TIMESTAMP(3),

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Team" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "plan" TEXT NOT NULL DEFAULT 'free',
    "stripeId" TEXT,
    "subscriptionId" TEXT,
    "startsAt" TIMESTAMP(3),
    "endsAt" TIMESTAMP(3),
    "limits" JSONB,
    "enableExcelAdvancedMode" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "ignoredDomains" TEXT[],
    "globalBlockList" TEXT[],

    CONSTRAINT "Team_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Brand" (
    "id" TEXT NOT NULL,
    "logo" TEXT,
    "brandColor" TEXT,
    "accentColor" TEXT,
    "teamId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Brand_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserTeam" (
    "role" "Role" NOT NULL DEFAULT 'MEMBER',
    "status" TEXT NOT NULL DEFAULT 'ACTIVE',
    "userId" TEXT NOT NULL,
    "teamId" TEXT NOT NULL,
    "blockedAt" TIMESTAMP(3),
    "notificationPreferences" JSONB,

    CONSTRAINT "UserTeam_pkey" PRIMARY KEY ("userId","teamId")
);

-- CreateTable
CREATE TABLE "VerificationToken" (
    "identifier" TEXT NOT NULL,
    "token" TEXT NOT NULL,
    "expires" TIMESTAMP(3) NOT NULL
);

-- CreateTable
CREATE TABLE "Document" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "file" TEXT NOT NULL,
    "originalFile" TEXT,
    "type" TEXT,
    "contentType" TEXT,
    "storageType" "DocumentStorageType" NOT NULL DEFAULT 'VERCEL_BLOB',
    "numPages" INTEGER,
    "teamId" TEXT NOT NULL,
    "ownerId" TEXT,
    "assistantEnabled" BOOLEAN NOT NULL DEFAULT false,
    "advancedExcelEnabled" BOOLEAN NOT NULL DEFAULT false,
    "downloadOnly" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "folderId" TEXT,
    "isExternalUpload" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "Document_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DocumentVersion" (
    "id" TEXT NOT NULL,
    "versionNumber" INTEGER NOT NULL,
    "documentId" TEXT NOT NULL,
    "file" TEXT NOT NULL,
    "originalFile" TEXT,
    "type" TEXT,
    "contentType" TEXT,
    "fileSize" INTEGER,
    "storageType" "DocumentStorageType" NOT NULL DEFAULT 'VERCEL_BLOB',
    "numPages" INTEGER,
    "isPrimary" BOOLEAN NOT NULL DEFAULT false,
    "isVertical" BOOLEAN NOT NULL DEFAULT false,
    "fileId" TEXT,
    "hasPages" BOOLEAN NOT NULL DEFAULT false,
    "length" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "DocumentVersion_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DocumentPage" (
    "id" TEXT NOT NULL,
    "versionId" TEXT NOT NULL,
    "pageNumber" INTEGER NOT NULL,
    "embeddedLinks" TEXT[],
    "pageLinks" JSONB,
    "metadata" JSONB,
    "file" TEXT NOT NULL,
    "storageType" "DocumentStorageType" NOT NULL DEFAULT 'VERCEL_BLOB',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "DocumentPage_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Domain" (
    "id" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "userId" TEXT,
    "teamId" TEXT NOT NULL,
    "verified" BOOLEAN NOT NULL DEFAULT false,
    "isDefault" BOOLEAN NOT NULL DEFAULT false,
    "lastChecked" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Domain_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "View" (
    "id" TEXT NOT NULL,
    "linkId" TEXT NOT NULL,
    "documentId" TEXT,
    "dataroomId" TEXT,
    "dataroomViewId" TEXT,
    "viewerEmail" TEXT,
    "viewerName" TEXT,
    "verified" BOOLEAN NOT NULL DEFAULT false,
    "viewedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "downloadedAt" TIMESTAMP(3),
    "viewType" "ViewType" NOT NULL DEFAULT 'DOCUMENT_VIEW',
    "viewerId" TEXT,
    "groupId" TEXT,
    "isArchived" BOOLEAN NOT NULL DEFAULT false,
    "teamId" TEXT,

    CONSTRAINT "View_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Viewer" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "verified" BOOLEAN NOT NULL DEFAULT false,
    "invitedAt" TIMESTAMP(3),
    "notificationPreferences" JSONB,
    "dataroomId" TEXT,
    "teamId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Viewer_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Reaction" (
    "id" TEXT NOT NULL,
    "viewId" TEXT NOT NULL,
    "pageNumber" INTEGER NOT NULL,
    "type" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Reaction_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Invitation" (
    "email" TEXT NOT NULL,
    "expires" TIMESTAMP(3) NOT NULL,
    "teamId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "token" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "SentEmail" (
    "id" TEXT NOT NULL,
    "type" "EmailType" NOT NULL,
    "recipient" TEXT NOT NULL,
    "marketing" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "teamId" TEXT NOT NULL,
    "domainSlug" TEXT,

    CONSTRAINT "SentEmail_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Chat" (
    "id" TEXT NOT NULL,
    "threadId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "documentId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "lastMessageAt" TIMESTAMP(3),

    CONSTRAINT "Chat_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Folder" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "path" TEXT NOT NULL,
    "parentId" TEXT,
    "teamId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Folder_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Feedback" (
    "id" TEXT NOT NULL,
    "linkId" TEXT NOT NULL,
    "data" JSONB NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Feedback_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "FeedbackResponse" (
    "id" TEXT NOT NULL,
    "feedbackId" TEXT NOT NULL,
    "data" JSONB NOT NULL,
    "viewId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "FeedbackResponse_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Agreement" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "requireName" BOOLEAN NOT NULL DEFAULT true,
    "teamId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),
    "deletedBy" TEXT,

    CONSTRAINT "Agreement_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AgreementResponse" (
    "id" TEXT NOT NULL,
    "agreementId" TEXT NOT NULL,
    "viewId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "AgreementResponse_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "IncomingWebhook" (
    "id" TEXT NOT NULL,
    "externalId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "secret" TEXT,
    "source" TEXT,
    "actions" TEXT,
    "consecutiveFailures" INTEGER NOT NULL DEFAULT 0,
    "lastFailedAt" TIMESTAMP(3),
    "disabledAt" TIMESTAMP(3),
    "teamId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "IncomingWebhook_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RestrictedToken" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "hashedKey" TEXT NOT NULL,
    "partialKey" TEXT NOT NULL,
    "scopes" TEXT,
    "expires" TIMESTAMP(3),
    "lastUsed" TIMESTAMP(3),
    "rateLimit" INTEGER NOT NULL DEFAULT 60,
    "userId" TEXT NOT NULL,
    "teamId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "RestrictedToken_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Webhook" (
    "id" TEXT NOT NULL,
    "pId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "url" TEXT NOT NULL,
    "secret" TEXT NOT NULL,
    "triggers" JSONB NOT NULL,
    "teamId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Webhook_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "YearInReview" (
    "id" TEXT NOT NULL,
    "teamId" TEXT NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'pending',
    "attempts" INTEGER NOT NULL DEFAULT 0,
    "lastAttempted" TIMESTAMP(3),
    "error" TEXT,
    "stats" JSONB NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "YearInReview_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DocumentUpload" (
    "id" TEXT NOT NULL,
    "documentId" TEXT NOT NULL,
    "teamId" TEXT NOT NULL,
    "viewerId" TEXT,
    "viewId" TEXT,
    "linkId" TEXT NOT NULL,
    "dataroomId" TEXT,
    "dataroomDocumentId" TEXT,
    "originalFilename" TEXT,
    "fileSize" INTEGER,
    "numPages" INTEGER,
    "mimeType" TEXT,
    "uploadedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "DocumentUpload_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Tag" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "color" TEXT NOT NULL,
    "description" TEXT,
    "teamId" TEXT NOT NULL,
    "createdBy" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Tag_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TagItem" (
    "id" TEXT NOT NULL,
    "tagId" TEXT NOT NULL,
    "itemType" "TagType" NOT NULL,
    "linkId" TEXT,
    "documentId" TEXT,
    "dataroomId" TEXT,
    "taggedBy" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "TagItem_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "Conversation_dataroomId_idx" ON "Conversation"("dataroomId");

-- CreateIndex
CREATE INDEX "Conversation_dataroomDocumentId_idx" ON "Conversation"("dataroomDocumentId");

-- CreateIndex
CREATE INDEX "Conversation_linkId_idx" ON "Conversation"("linkId");

-- CreateIndex
CREATE INDEX "Conversation_teamId_idx" ON "Conversation"("teamId");

-- CreateIndex
CREATE INDEX "Conversation_viewerGroupId_idx" ON "Conversation"("viewerGroupId");

-- CreateIndex
CREATE INDEX "Conversation_initialViewId_idx" ON "Conversation"("initialViewId");

-- CreateIndex
CREATE INDEX "ConversationParticipant_conversationId_idx" ON "ConversationParticipant"("conversationId");

-- CreateIndex
CREATE INDEX "ConversationParticipant_viewerId_idx" ON "ConversationParticipant"("viewerId");

-- CreateIndex
CREATE INDEX "ConversationParticipant_userId_idx" ON "ConversationParticipant"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "ConversationParticipant_conversationId_viewerId_key" ON "ConversationParticipant"("conversationId", "viewerId");

-- CreateIndex
CREATE UNIQUE INDEX "ConversationParticipant_conversationId_userId_key" ON "ConversationParticipant"("conversationId", "userId");

-- CreateIndex
CREATE INDEX "Message_conversationId_idx" ON "Message"("conversationId");

-- CreateIndex
CREATE INDEX "Message_userId_idx" ON "Message"("userId");

-- CreateIndex
CREATE INDEX "Message_viewerId_idx" ON "Message"("viewerId");

-- CreateIndex
CREATE INDEX "Message_viewId_idx" ON "Message"("viewId");

-- CreateIndex
CREATE INDEX "ConversationView_conversationId_idx" ON "ConversationView"("conversationId");

-- CreateIndex
CREATE INDEX "ConversationView_viewId_idx" ON "ConversationView"("viewId");

-- CreateIndex
CREATE UNIQUE INDEX "ConversationView_conversationId_viewId_key" ON "ConversationView"("conversationId", "viewId");

-- CreateIndex
CREATE UNIQUE INDEX "Dataroom_pId_key" ON "Dataroom"("pId");

-- CreateIndex
CREATE INDEX "Dataroom_teamId_idx" ON "Dataroom"("teamId");

-- CreateIndex
CREATE INDEX "DataroomDocument_folderId_idx" ON "DataroomDocument"("folderId");

-- CreateIndex
CREATE INDEX "DataroomDocument_dataroomId_folderId_orderIndex_idx" ON "DataroomDocument"("dataroomId", "folderId", "orderIndex");

-- CreateIndex
CREATE UNIQUE INDEX "DataroomDocument_dataroomId_documentId_key" ON "DataroomDocument"("dataroomId", "documentId");

-- CreateIndex
CREATE INDEX "DataroomFolder_parentId_idx" ON "DataroomFolder"("parentId");

-- CreateIndex
CREATE INDEX "DataroomFolder_dataroomId_parentId_orderIndex_idx" ON "DataroomFolder"("dataroomId", "parentId", "orderIndex");

-- CreateIndex
CREATE UNIQUE INDEX "DataroomFolder_dataroomId_path_key" ON "DataroomFolder"("dataroomId", "path");

-- CreateIndex
CREATE UNIQUE INDEX "DataroomBrand_dataroomId_key" ON "DataroomBrand"("dataroomId");

-- CreateIndex
CREATE INDEX "ViewerGroup_dataroomId_idx" ON "ViewerGroup"("dataroomId");

-- CreateIndex
CREATE INDEX "ViewerGroup_teamId_idx" ON "ViewerGroup"("teamId");

-- CreateIndex
CREATE INDEX "ViewerGroupMembership_viewerId_idx" ON "ViewerGroupMembership"("viewerId");

-- CreateIndex
CREATE INDEX "ViewerGroupMembership_groupId_idx" ON "ViewerGroupMembership"("groupId");

-- CreateIndex
CREATE UNIQUE INDEX "ViewerGroupMembership_viewerId_groupId_key" ON "ViewerGroupMembership"("viewerId", "groupId");

-- CreateIndex
CREATE INDEX "ViewerGroupAccessControls_groupId_idx" ON "ViewerGroupAccessControls"("groupId");

-- CreateIndex
CREATE UNIQUE INDEX "ViewerGroupAccessControls_groupId_itemId_key" ON "ViewerGroupAccessControls"("groupId", "itemId");

-- CreateIndex
CREATE INDEX "PermissionGroup_dataroomId_idx" ON "PermissionGroup"("dataroomId");

-- CreateIndex
CREATE INDEX "PermissionGroup_teamId_idx" ON "PermissionGroup"("teamId");

-- CreateIndex
CREATE INDEX "PermissionGroupAccessControls_groupId_idx" ON "PermissionGroupAccessControls"("groupId");

-- CreateIndex
CREATE UNIQUE INDEX "PermissionGroupAccessControls_groupId_itemId_key" ON "PermissionGroupAccessControls"("groupId", "itemId");

-- CreateIndex
CREATE UNIQUE INDEX "Link_url_key" ON "Link"("url");

-- CreateIndex
CREATE INDEX "Link_documentId_idx" ON "Link"("documentId");

-- CreateIndex
CREATE INDEX "Link_teamId_idx" ON "Link"("teamId");

-- CreateIndex
CREATE UNIQUE INDEX "Link_domainSlug_slug_key" ON "Link"("domainSlug", "slug");

-- CreateIndex
CREATE UNIQUE INDEX "LinkPreset_pId_key" ON "LinkPreset"("pId");

-- CreateIndex
CREATE INDEX "LinkPreset_teamId_idx" ON "LinkPreset"("teamId");

-- CreateIndex
CREATE INDEX "CustomField_linkId_idx" ON "CustomField"("linkId");

-- CreateIndex
CREATE UNIQUE INDEX "CustomFieldResponse_viewId_key" ON "CustomFieldResponse"("viewId");

-- CreateIndex
CREATE INDEX "CustomFieldResponse_viewId_idx" ON "CustomFieldResponse"("viewId");

-- CreateIndex
CREATE UNIQUE INDEX "Account_provider_providerAccountId_key" ON "Account"("provider", "providerAccountId");

-- CreateIndex
CREATE UNIQUE INDEX "Session_sessionToken_key" ON "Session"("sessionToken");

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "User_stripeId_key" ON "User"("stripeId");

-- CreateIndex
CREATE UNIQUE INDEX "User_subscriptionId_key" ON "User"("subscriptionId");

-- CreateIndex
CREATE UNIQUE INDEX "Team_stripeId_key" ON "Team"("stripeId");

-- CreateIndex
CREATE UNIQUE INDEX "Team_subscriptionId_key" ON "Team"("subscriptionId");

-- CreateIndex
CREATE UNIQUE INDEX "Brand_teamId_key" ON "Brand"("teamId");

-- CreateIndex
CREATE INDEX "UserTeam_userId_idx" ON "UserTeam"("userId");

-- CreateIndex
CREATE INDEX "UserTeam_teamId_idx" ON "UserTeam"("teamId");

-- CreateIndex
CREATE UNIQUE INDEX "VerificationToken_token_key" ON "VerificationToken"("token");

-- CreateIndex
CREATE UNIQUE INDEX "VerificationToken_identifier_token_key" ON "VerificationToken"("identifier", "token");

-- CreateIndex
CREATE INDEX "Document_ownerId_idx" ON "Document"("ownerId");

-- CreateIndex
CREATE INDEX "Document_teamId_idx" ON "Document"("teamId");

-- CreateIndex
CREATE INDEX "Document_folderId_idx" ON "Document"("folderId");

-- CreateIndex
CREATE INDEX "DocumentVersion_documentId_idx" ON "DocumentVersion"("documentId");

-- CreateIndex
CREATE UNIQUE INDEX "DocumentVersion_versionNumber_documentId_key" ON "DocumentVersion"("versionNumber", "documentId");

-- CreateIndex
CREATE INDEX "DocumentPage_versionId_idx" ON "DocumentPage"("versionId");

-- CreateIndex
CREATE UNIQUE INDEX "DocumentPage_pageNumber_versionId_key" ON "DocumentPage"("pageNumber", "versionId");

-- CreateIndex
CREATE UNIQUE INDEX "Domain_slug_key" ON "Domain"("slug");

-- CreateIndex
CREATE INDEX "Domain_userId_idx" ON "Domain"("userId");

-- CreateIndex
CREATE INDEX "Domain_teamId_idx" ON "Domain"("teamId");

-- CreateIndex
CREATE INDEX "View_linkId_idx" ON "View"("linkId");

-- CreateIndex
CREATE INDEX "View_documentId_idx" ON "View"("documentId");

-- CreateIndex
CREATE INDEX "View_dataroomId_idx" ON "View"("dataroomId");

-- CreateIndex
CREATE INDEX "View_dataroomViewId_idx" ON "View"("dataroomViewId");

-- CreateIndex
CREATE INDEX "View_viewerId_idx" ON "View"("viewerId");

-- CreateIndex
CREATE INDEX "View_teamId_idx" ON "View"("teamId");

-- CreateIndex
CREATE INDEX "View_viewedAt_idx" ON "View"("viewedAt" DESC);

-- CreateIndex
CREATE INDEX "View_viewerId_documentId_idx" ON "View"("viewerId", "documentId");

-- CreateIndex
CREATE INDEX "Viewer_teamId_idx" ON "Viewer"("teamId");

-- CreateIndex
CREATE INDEX "Viewer_dataroomId_idx" ON "Viewer"("dataroomId");

-- CreateIndex
CREATE UNIQUE INDEX "Viewer_teamId_email_key" ON "Viewer"("teamId", "email");

-- CreateIndex
CREATE INDEX "Reaction_viewId_idx" ON "Reaction"("viewId");

-- CreateIndex
CREATE UNIQUE INDEX "Invitation_token_key" ON "Invitation"("token");

-- CreateIndex
CREATE UNIQUE INDEX "Invitation_email_teamId_key" ON "Invitation"("email", "teamId");

-- CreateIndex
CREATE INDEX "SentEmail_teamId_idx" ON "SentEmail"("teamId");

-- CreateIndex
CREATE UNIQUE INDEX "Chat_threadId_key" ON "Chat"("threadId");

-- CreateIndex
CREATE INDEX "Chat_threadId_idx" ON "Chat"("threadId");

-- CreateIndex
CREATE UNIQUE INDEX "Chat_userId_documentId_key" ON "Chat"("userId", "documentId");

-- CreateIndex
CREATE UNIQUE INDEX "Chat_threadId_documentId_key" ON "Chat"("threadId", "documentId");

-- CreateIndex
CREATE INDEX "Folder_parentId_idx" ON "Folder"("parentId");

-- CreateIndex
CREATE UNIQUE INDEX "Folder_teamId_path_key" ON "Folder"("teamId", "path");

-- CreateIndex
CREATE UNIQUE INDEX "Feedback_linkId_key" ON "Feedback"("linkId");

-- CreateIndex
CREATE INDEX "Feedback_linkId_idx" ON "Feedback"("linkId");

-- CreateIndex
CREATE UNIQUE INDEX "FeedbackResponse_viewId_key" ON "FeedbackResponse"("viewId");

-- CreateIndex
CREATE INDEX "FeedbackResponse_feedbackId_idx" ON "FeedbackResponse"("feedbackId");

-- CreateIndex
CREATE INDEX "FeedbackResponse_viewId_idx" ON "FeedbackResponse"("viewId");

-- CreateIndex
CREATE INDEX "Agreement_teamId_idx" ON "Agreement"("teamId");

-- CreateIndex
CREATE UNIQUE INDEX "AgreementResponse_viewId_key" ON "AgreementResponse"("viewId");

-- CreateIndex
CREATE INDEX "AgreementResponse_agreementId_idx" ON "AgreementResponse"("agreementId");

-- CreateIndex
CREATE INDEX "AgreementResponse_viewId_idx" ON "AgreementResponse"("viewId");

-- CreateIndex
CREATE UNIQUE INDEX "IncomingWebhook_externalId_key" ON "IncomingWebhook"("externalId");

-- CreateIndex
CREATE INDEX "IncomingWebhook_teamId_idx" ON "IncomingWebhook"("teamId");

-- CreateIndex
CREATE UNIQUE INDEX "RestrictedToken_hashedKey_key" ON "RestrictedToken"("hashedKey");

-- CreateIndex
CREATE INDEX "RestrictedToken_userId_idx" ON "RestrictedToken"("userId");

-- CreateIndex
CREATE INDEX "RestrictedToken_teamId_idx" ON "RestrictedToken"("teamId");

-- CreateIndex
CREATE UNIQUE INDEX "Webhook_pId_key" ON "Webhook"("pId");

-- CreateIndex
CREATE INDEX "Webhook_teamId_idx" ON "Webhook"("teamId");

-- CreateIndex
CREATE INDEX "YearInReview_status_attempts_idx" ON "YearInReview"("status", "attempts");

-- CreateIndex
CREATE INDEX "YearInReview_teamId_idx" ON "YearInReview"("teamId");

-- CreateIndex
CREATE INDEX "DocumentUpload_documentId_idx" ON "DocumentUpload"("documentId");

-- CreateIndex
CREATE INDEX "DocumentUpload_viewerId_idx" ON "DocumentUpload"("viewerId");

-- CreateIndex
CREATE INDEX "DocumentUpload_viewId_idx" ON "DocumentUpload"("viewId");

-- CreateIndex
CREATE INDEX "DocumentUpload_linkId_idx" ON "DocumentUpload"("linkId");

-- CreateIndex
CREATE INDEX "DocumentUpload_teamId_idx" ON "DocumentUpload"("teamId");

-- CreateIndex
CREATE INDEX "DocumentUpload_dataroomId_idx" ON "DocumentUpload"("dataroomId");

-- CreateIndex
CREATE INDEX "DocumentUpload_dataroomDocumentId_idx" ON "DocumentUpload"("dataroomDocumentId");

-- CreateIndex
CREATE INDEX "Tag_teamId_idx" ON "Tag"("teamId");

-- CreateIndex
CREATE INDEX "Tag_name_idx" ON "Tag"("name");

-- CreateIndex
CREATE INDEX "Tag_id_idx" ON "Tag"("id");

-- CreateIndex
CREATE UNIQUE INDEX "Tag_teamId_name_key" ON "Tag"("teamId", "name");

-- CreateIndex
CREATE INDEX "TagItem_tagId_linkId_idx" ON "TagItem"("tagId", "linkId");

-- CreateIndex
CREATE INDEX "TagItem_tagId_documentId_idx" ON "TagItem"("tagId", "documentId");

-- CreateIndex
CREATE INDEX "TagItem_tagId_dataroomId_idx" ON "TagItem"("tagId", "dataroomId");

-- AddForeignKey
ALTER TABLE "Conversation" ADD CONSTRAINT "Conversation_dataroomId_fkey" FOREIGN KEY ("dataroomId") REFERENCES "Dataroom"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Conversation" ADD CONSTRAINT "Conversation_dataroomDocumentId_fkey" FOREIGN KEY ("dataroomDocumentId") REFERENCES "DataroomDocument"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Conversation" ADD CONSTRAINT "Conversation_linkId_fkey" FOREIGN KEY ("linkId") REFERENCES "Link"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Conversation" ADD CONSTRAINT "Conversation_viewerGroupId_fkey" FOREIGN KEY ("viewerGroupId") REFERENCES "ViewerGroup"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Conversation" ADD CONSTRAINT "Conversation_initialViewId_fkey" FOREIGN KEY ("initialViewId") REFERENCES "View"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Conversation" ADD CONSTRAINT "Conversation_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES "Team"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ConversationParticipant" ADD CONSTRAINT "ConversationParticipant_conversationId_fkey" FOREIGN KEY ("conversationId") REFERENCES "Conversation"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ConversationParticipant" ADD CONSTRAINT "ConversationParticipant_viewerId_fkey" FOREIGN KEY ("viewerId") REFERENCES "Viewer"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ConversationParticipant" ADD CONSTRAINT "ConversationParticipant_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Message" ADD CONSTRAINT "Message_conversationId_fkey" FOREIGN KEY ("conversationId") REFERENCES "Conversation"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Message" ADD CONSTRAINT "Message_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Message" ADD CONSTRAINT "Message_viewerId_fkey" FOREIGN KEY ("viewerId") REFERENCES "Viewer"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Message" ADD CONSTRAINT "Message_viewId_fkey" FOREIGN KEY ("viewId") REFERENCES "View"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ConversationView" ADD CONSTRAINT "ConversationView_conversationId_fkey" FOREIGN KEY ("conversationId") REFERENCES "Conversation"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ConversationView" ADD CONSTRAINT "ConversationView_viewId_fkey" FOREIGN KEY ("viewId") REFERENCES "View"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Dataroom" ADD CONSTRAINT "Dataroom_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES "Team"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DataroomDocument" ADD CONSTRAINT "DataroomDocument_dataroomId_fkey" FOREIGN KEY ("dataroomId") REFERENCES "Dataroom"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DataroomDocument" ADD CONSTRAINT "DataroomDocument_documentId_fkey" FOREIGN KEY ("documentId") REFERENCES "Document"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DataroomDocument" ADD CONSTRAINT "DataroomDocument_folderId_fkey" FOREIGN KEY ("folderId") REFERENCES "DataroomFolder"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DataroomFolder" ADD CONSTRAINT "DataroomFolder_parentId_fkey" FOREIGN KEY ("parentId") REFERENCES "DataroomFolder"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DataroomFolder" ADD CONSTRAINT "DataroomFolder_dataroomId_fkey" FOREIGN KEY ("dataroomId") REFERENCES "Dataroom"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DataroomBrand" ADD CONSTRAINT "DataroomBrand_dataroomId_fkey" FOREIGN KEY ("dataroomId") REFERENCES "Dataroom"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ViewerGroup" ADD CONSTRAINT "ViewerGroup_dataroomId_fkey" FOREIGN KEY ("dataroomId") REFERENCES "Dataroom"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ViewerGroup" ADD CONSTRAINT "ViewerGroup_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES "Team"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ViewerGroupMembership" ADD CONSTRAINT "ViewerGroupMembership_viewerId_fkey" FOREIGN KEY ("viewerId") REFERENCES "Viewer"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ViewerGroupMembership" ADD CONSTRAINT "ViewerGroupMembership_groupId_fkey" FOREIGN KEY ("groupId") REFERENCES "ViewerGroup"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ViewerGroupAccessControls" ADD CONSTRAINT "ViewerGroupAccessControls_groupId_fkey" FOREIGN KEY ("groupId") REFERENCES "ViewerGroup"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PermissionGroup" ADD CONSTRAINT "PermissionGroup_dataroomId_fkey" FOREIGN KEY ("dataroomId") REFERENCES "Dataroom"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PermissionGroup" ADD CONSTRAINT "PermissionGroup_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES "Team"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PermissionGroupAccessControls" ADD CONSTRAINT "PermissionGroupAccessControls_groupId_fkey" FOREIGN KEY ("groupId") REFERENCES "PermissionGroup"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Link" ADD CONSTRAINT "Link_documentId_fkey" FOREIGN KEY ("documentId") REFERENCES "Document"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Link" ADD CONSTRAINT "Link_dataroomId_fkey" FOREIGN KEY ("dataroomId") REFERENCES "Dataroom"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Link" ADD CONSTRAINT "Link_domainId_fkey" FOREIGN KEY ("domainId") REFERENCES "Domain"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Link" ADD CONSTRAINT "Link_agreementId_fkey" FOREIGN KEY ("agreementId") REFERENCES "Agreement"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Link" ADD CONSTRAINT "Link_groupId_fkey" FOREIGN KEY ("groupId") REFERENCES "ViewerGroup"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Link" ADD CONSTRAINT "Link_permissionGroupId_fkey" FOREIGN KEY ("permissionGroupId") REFERENCES "PermissionGroup"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Link" ADD CONSTRAINT "Link_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES "Team"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LinkPreset" ADD CONSTRAINT "LinkPreset_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES "Team"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CustomField" ADD CONSTRAINT "CustomField_linkId_fkey" FOREIGN KEY ("linkId") REFERENCES "Link"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CustomFieldResponse" ADD CONSTRAINT "CustomFieldResponse_viewId_fkey" FOREIGN KEY ("viewId") REFERENCES "View"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Account" ADD CONSTRAINT "Account_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Session" ADD CONSTRAINT "Session_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Brand" ADD CONSTRAINT "Brand_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES "Team"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserTeam" ADD CONSTRAINT "UserTeam_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserTeam" ADD CONSTRAINT "UserTeam_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES "Team"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Document" ADD CONSTRAINT "Document_ownerId_fkey" FOREIGN KEY ("ownerId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Document" ADD CONSTRAINT "Document_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES "Team"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Document" ADD CONSTRAINT "Document_folderId_fkey" FOREIGN KEY ("folderId") REFERENCES "Folder"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DocumentVersion" ADD CONSTRAINT "DocumentVersion_documentId_fkey" FOREIGN KEY ("documentId") REFERENCES "Document"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DocumentPage" ADD CONSTRAINT "DocumentPage_versionId_fkey" FOREIGN KEY ("versionId") REFERENCES "DocumentVersion"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Domain" ADD CONSTRAINT "Domain_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Domain" ADD CONSTRAINT "Domain_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES "Team"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "View" ADD CONSTRAINT "View_linkId_fkey" FOREIGN KEY ("linkId") REFERENCES "Link"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "View" ADD CONSTRAINT "View_documentId_fkey" FOREIGN KEY ("documentId") REFERENCES "Document"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "View" ADD CONSTRAINT "View_dataroomId_fkey" FOREIGN KEY ("dataroomId") REFERENCES "Dataroom"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "View" ADD CONSTRAINT "View_viewerId_fkey" FOREIGN KEY ("viewerId") REFERENCES "Viewer"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "View" ADD CONSTRAINT "View_groupId_fkey" FOREIGN KEY ("groupId") REFERENCES "ViewerGroup"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "View" ADD CONSTRAINT "View_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES "Team"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Viewer" ADD CONSTRAINT "Viewer_dataroomId_fkey" FOREIGN KEY ("dataroomId") REFERENCES "Dataroom"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Viewer" ADD CONSTRAINT "Viewer_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES "Team"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Reaction" ADD CONSTRAINT "Reaction_viewId_fkey" FOREIGN KEY ("viewId") REFERENCES "View"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Invitation" ADD CONSTRAINT "Invitation_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES "Team"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SentEmail" ADD CONSTRAINT "SentEmail_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES "Team"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Chat" ADD CONSTRAINT "Chat_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Chat" ADD CONSTRAINT "Chat_documentId_fkey" FOREIGN KEY ("documentId") REFERENCES "Document"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Folder" ADD CONSTRAINT "Folder_parentId_fkey" FOREIGN KEY ("parentId") REFERENCES "Folder"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Folder" ADD CONSTRAINT "Folder_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES "Team"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Feedback" ADD CONSTRAINT "Feedback_linkId_fkey" FOREIGN KEY ("linkId") REFERENCES "Link"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FeedbackResponse" ADD CONSTRAINT "FeedbackResponse_feedbackId_fkey" FOREIGN KEY ("feedbackId") REFERENCES "Feedback"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FeedbackResponse" ADD CONSTRAINT "FeedbackResponse_viewId_fkey" FOREIGN KEY ("viewId") REFERENCES "View"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Agreement" ADD CONSTRAINT "Agreement_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES "Team"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AgreementResponse" ADD CONSTRAINT "AgreementResponse_agreementId_fkey" FOREIGN KEY ("agreementId") REFERENCES "Agreement"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AgreementResponse" ADD CONSTRAINT "AgreementResponse_viewId_fkey" FOREIGN KEY ("viewId") REFERENCES "View"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "IncomingWebhook" ADD CONSTRAINT "IncomingWebhook_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES "Team"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RestrictedToken" ADD CONSTRAINT "RestrictedToken_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RestrictedToken" ADD CONSTRAINT "RestrictedToken_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES "Team"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Webhook" ADD CONSTRAINT "Webhook_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES "Team"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DocumentUpload" ADD CONSTRAINT "DocumentUpload_documentId_fkey" FOREIGN KEY ("documentId") REFERENCES "Document"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DocumentUpload" ADD CONSTRAINT "DocumentUpload_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES "Team"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DocumentUpload" ADD CONSTRAINT "DocumentUpload_viewerId_fkey" FOREIGN KEY ("viewerId") REFERENCES "Viewer"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DocumentUpload" ADD CONSTRAINT "DocumentUpload_viewId_fkey" FOREIGN KEY ("viewId") REFERENCES "View"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DocumentUpload" ADD CONSTRAINT "DocumentUpload_linkId_fkey" FOREIGN KEY ("linkId") REFERENCES "Link"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DocumentUpload" ADD CONSTRAINT "DocumentUpload_dataroomId_fkey" FOREIGN KEY ("dataroomId") REFERENCES "Dataroom"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DocumentUpload" ADD CONSTRAINT "DocumentUpload_dataroomDocumentId_fkey" FOREIGN KEY ("dataroomDocumentId") REFERENCES "DataroomDocument"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Tag" ADD CONSTRAINT "Tag_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES "Team"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TagItem" ADD CONSTRAINT "TagItem_tagId_fkey" FOREIGN KEY ("tagId") REFERENCES "Tag"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TagItem" ADD CONSTRAINT "TagItem_linkId_fkey" FOREIGN KEY ("linkId") REFERENCES "Link"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TagItem" ADD CONSTRAINT "TagItem_documentId_fkey" FOREIGN KEY ("documentId") REFERENCES "Document"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TagItem" ADD CONSTRAINT "TagItem_dataroomId_fkey" FOREIGN KEY ("dataroomId") REFERENCES "Dataroom"("id") ON DELETE CASCADE ON UPDATE CASCADE;
