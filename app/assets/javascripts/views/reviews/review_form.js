Goodrides.Views.ReviewForm = Backbone.LinkFormView.extend({
  formTemplate: JST['reviews/form'],
  linkTemplate: JST['reviews/form_link'],

  create: function (event) {
    event.preventDefault();
    this.collection.create({
      ride_id: this.collection.ride.id,
      star_rating: this.$('textarea').val()
    }, { wait: true });
    this.$('textarea').val('');
    this.$('textarea').focus();
  }
});
