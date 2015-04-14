Goodrides.Views.ReviewForm = Backbone.CompositeView.extend({
  formTemplate: JST['reviews/form'],
  linkTemplate: JST['reviews/form_link'],
  starTemplate: JST['reviews/stars'],
  formShowing: false,

  initialize: function (options) {
    this.rideShowView = options.rideShowView
  },

  setStarRating: function (rating) {
    this.collection.create({
      ride_id: this.collection.ride.id,
      star_rating: rating
    });
  },

  create: function (event) {
    event.preventDefault();
    this.collection.create({
      ride_id: this.collection.ride.id,
      star_rating: this.rating,
      body: $('textarea').val()
    }, { wait: true });
    this.$el.empty();
    this.rideShowView.showUserStars(this.rating);
    this.rideShowView.averageStarDisplay(this.rating);
    // this.$('textarea').val('');
    // this.$('textarea').focus();
  },
// TODO:
  events: {
    'click a' : 'showForm',
    'click .close' : 'hideForm',
    'submit' : 'create',
    'keydown textarea' : 'maybeCreate'
  },

  initializeStarPlugin: function () {
    var renderForm;
    var firstTime;

    if (this.formShowing) {
      renderForm = this.initializeStarPlugin.bind(this);
    } else {
      renderForm = this.showForm.bind(this);
    }

    this.$("#rateYo").rateYo({
      halfStar: true,
      rating: this.rating
    }).on("rateyo.set", function (e, data) {
      this.rating = data.rating;
      renderForm();
    }.bind(this));
  },

  // TODO: changing score multiple times is doing something that takes up memory,
  // figure it out

  render: function () {
    var content;
    if (this.formShowing) {
      content = this.formTemplate();
    } else {
      content = this.linkTemplate();
    }
    this.$el.html(content);
    this.initializeStarPlugin();
    this.delegateEvents();
    return this;
  },

  hideForm: function () {
    this.formShowing = false;
    this.render();
  },

  maybeCreate: function (event) {
    if (event.keyCode === 13) {
      this.create(event);
    }
  },

  showForm: function (event) {
    if (event) {
      event.preventDefault();
    }
    this.formShowing = true;
    this.render();
  }
});
