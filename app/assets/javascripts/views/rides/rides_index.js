Goodrides.Views.RidesIndex = Backbone.View.extend({
  template: JST['rides/index'],

  className: 'rides-index',

  initialize: function () {
    this.listenTo(this.collection, 'sync', this.render);
  },

  render: function () {
    var content = this.template({
      rides: this.collection
    });

    this.$el.html(content);
    return this;
  }
});