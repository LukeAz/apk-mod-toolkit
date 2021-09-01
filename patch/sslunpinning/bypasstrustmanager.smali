.class public Lsslunpinning/bypasstrustmanager;
.super Ljava/lang/Object;
.source "SourceFile"

# direct methods

.method constructor <init>()V
    .registers 1
    .prologue
    
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method

.method public static getInstance()Ljavax/net/ssl/TrustManager;
    .registers 1
    .prologue

    new-instance v0, Lsslunpinning/bypasstrustmanager$1;
    invoke-direct {v0}, Lsslunpinning/bypasstrustmanager$1;-><init>()V
    return-object v0
.end method