from django.urls import path
from authentification import views
from rest_framework.authtoken import views as drfviews

urlpatterns = [
    path('', views.home, name='home'),
    path('signup', views.signup, name='signup'),
    path('signin', views.signin, name='signin'),
    path('signout', views.signout, name='signout'),
    path('activate/<uidb64>/<token>', views.activate, name='activate'),
    path('api-token-auth/', drfviews.obtain_auth_token),
    
]