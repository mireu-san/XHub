from rest_framework import serializers
from .models import Post


class PostSerializers(serializers.ModelSerializer):
    writer = serializers.ReadOnlyField(source='writer.email')
    like = serializers.ReadOnlyField()
    
    class Meta:
        model = Post
        fields = ['id', 'gather-title', 'writer', 'context', 'img', 'like', 'public', 'created_at', 'updated_at']