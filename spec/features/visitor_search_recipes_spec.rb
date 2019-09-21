# frozen_string_literal: true

require 'rails_helper'

feature 'Visitor search for recipes' do
  scenario 'sucessfully by its exact name' do
    recipe_type = RecipeType.create(name: 'Sobremesa')
    cuisine = Cuisine.create(name: 'Brasileira')
    user = User.create(email: 'alan@email.com', password: '123456')
    Recipe.create(title: 'Bolo de cenoura', difficulty: 'Médio',
                  recipe_type: recipe_type, cuisine: cuisine,
                  cook_time: 50, ingredients: 'Farinha, açucar, cenoura',
                  cook_method: 'Cozinhe a cenoura, corte em pedaços pequenos',
                  user: user)
    Recipe.create(title: 'Pão de Queijo', difficulty: 'Fácil',
                  recipe_type: recipe_type, cuisine: cuisine,
                  cook_time: 50, ingredients: 'Farinha, açucar, queijo',
                  cook_method: 'Misture, corte em pedaços pequenos',
                  user: user)

    visit root_path
    click_on 'Pesquisar no site'
    fill_in 'Título', with: 'Pão de Queijo'
    click_on 'Pesquisar'

    expect(page).to have_css('h3', text: 'Receitas encontradas')
    expect(page).to have_css('p', text: 'Pão de Queijo')
    expect(page).not_to have_content('Bolo de cenoura')
  end

  scenario 'and must fill title field to search' do
    recipe_type = RecipeType.create(name: 'Sobremesa')
    cuisine = Cuisine.create(name: 'Brasileira')
    user = User.create(email: 'alan@email.com', password: '123456')
    Recipe.create(title: 'Bolo de cenoura', difficulty: 'Médio',
                  recipe_type: recipe_type, cuisine: cuisine,
                  cook_time: 50, ingredients: 'Farinha, açucar, cenoura',
                  cook_method: 'Cozinhe a cenoura, corte em pedaços pequenos',
                  user: user)

    visit root_path
    click_on 'Pesquisar no site'
    fill_in 'Título', with: 'Bolo de fubá'
    click_on 'Pesquisar'

    expect(page).not_to have_content('Receitas encontradas')
    expect(page).not_to have_content('Bolo de cenoura')
    expect(page).to have_content('Não encontramos nada')
  end

  scenario 'by unexistant recipe and none is shown' do
    recipe_type = RecipeType.create(name: 'Sobremesa')
    cuisine = Cuisine.create(name: 'Brasileira')
    user = User.create(email: 'alan@email.com', password: '123456')
    Recipe.create(title: 'Bolo de cenoura', difficulty: 'Médio',
                  recipe_type: recipe_type, cuisine: cuisine,
                  cook_time: 50, ingredients: 'Farinha, açucar, cenoura',
                  cook_method: 'Cozinhe a cenoura, corte em pedaços pequenos',
                  user: user)

    visit root_path
    click_on 'Pesquisar no site'
    fill_in 'Título', with: ''
    click_on 'Pesquisar'

    expect(page).not_to have_content('Receitas encontradas')
    expect(page).not_to have_content('Bolo de cenoura')
    expect(page).to have_content('Preencha o campo de pesquisa')
  end

  scenario 'by its partial name and can show more than one result' do
    recipe_type = RecipeType.create(name: 'Sobremesa')
    cuisine = Cuisine.create(name: 'Brasileira')
    user = User.create(email: 'alan@email.com', password: '123456')
    Recipe.create(title: 'Bolo de cenoura', difficulty: 'Médio',
                  recipe_type: recipe_type, cuisine: cuisine,
                  cook_time: 50, ingredients: 'Farinha, açucar, cenoura',
                  cook_method: 'Cozinhe a cenoura, corte em pedaços pequenos',
                  user: user)
    Recipe.create(title: 'Bolo de Fubá', difficulty: 'Médio',
                  recipe_type: recipe_type, cuisine: cuisine,
                  cook_time: 50, ingredients: 'Farinha, açucar, cenoura',
                  cook_method: 'Cozinhe a cenoura, corte em pedaços pequenos',
                  user: user)
    Recipe.create(title: 'Bolo de Chocolate', difficulty: 'Médio',
                  recipe_type: recipe_type, cuisine: cuisine,
                  cook_time: 50, ingredients: 'Farinha, açucar, cenoura',
                  cook_method: 'Cozinhe a cenoura, corte em pedaços pequenos',
                  user: user)
    Recipe.create(title: 'Pão de Queijo', difficulty: 'Fácil',
                  recipe_type: recipe_type, cuisine: cuisine,
                  cook_time: 50, ingredients: 'Farinha, açucar, queijo',
                  cook_method: 'Misture, corte em pedaços pequenos',
                  user: user)

    visit root_path
    click_on 'Pesquisar no site'
    fill_in 'Título', with: 'Bolo'
    click_on 'Pesquisar'

    expect(page).to have_content('Receitas encontradas')
    expect(page).to have_css('p', text: 'Bolo de cenoura')
    expect(page).to have_css('p', text: 'Bolo de Fubá')
    expect(page).to have_css('p', text: 'Bolo de Chocolate')
    expect(page).not_to have_content('Pão de Queijo')
  end
end
