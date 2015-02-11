require 'test_helper'

class CommentairesControllerTest < ActionController::TestCase
  test "should get new" do
    sign_in contributeurs(:contrib)
    get :new, projet_id: 1
    assert_response :success
    assert_not_nil assigns(:commentaire)
  end

  test "ne pas poster de commentaires sans contributeur connecté" do 
    get :new, projet_id: 1
    assert_redirected_to new_contributeur_session_path
  end

  test "ne peux pas créer de commentaire si l'utilisateur n'est pas connecté" do
    post :create, projet_id: 1, commentaire: {message: 'yoo'}
    assert_redirected_to new_contributeur_session_path
  end

  test "ne pas créer un commentaire sans message" do
    sign_in contributeurs(:contrib)
    post :create, projet_id: 1, commentaire: {message: ''}
    assert_template :new
  end

  test "créer un commentaire valide" do
    sign_in contributeurs(:contrib)
    count = Commentaire.count
    post :create, projet_id: 1, commentaire: {message: 'yoo'}
    assert_not_nil assigns(:commentaire), "@commentaire doit être définis"
    assert_equal 'yoo', assigns(:commentaire).message, "Le commentaire ne contient pas de message"
    assert_equal count + 1, Commentaire.count, "Le Commentaire doit être sauvegardé dans la base"
    assert_equal 1, assigns(:commentaire).projet_id, "Le commentaire n'a pas été asocié au bon projet"
    assert_equal 1, assigns(:commentaire).contributeur_id, "Le commentaire n'a pas été associé au bon contributeur"
    assert_redirected_to projet_path(1), "L'utilisateur doit être redirigé vers `/projets/1`"
  end

end