(function($, ns) {
  ns.Presenter = ns.Presenter || {};

  ns.Presenter = (function(){
    function initializePresenters(target) {
      var $target = $(target);
      var $els = $target.find('[data-presents]').add($target.filter('[data-presents]'));

      $els.each(function() {
        var $el = $(this);
        if($el.attr('data-presented') === undefined){
          var presenters = $el.data('presents').split(' ');
          $el.attr('data-presented', presenters.join(' '));
          $.each(presenters, function() {
            var presenter = this;
            $el.trigger(presenter + ':present');
          });
        }
      });
    };

    var observerStrategies = {
      mutationObserver: function($el) {
        var observer = new MutationObserver(function(mutations) {
          mutations.map(function(mutation) {
            var nodes = $.makeArray(mutation.addedNodes);
            return nodes;
          }).forEach(function(node) {
            ns.Presenter.initializePresenters(node);
          });
        });

        observer.observe($el.get(0), { childList: true, subtree: true });
      },

      mutationEvent: function($el) {
        $el.on('DOMNodeInserted', function(event) {
          ns.Presenter.initializePresenters(event.target);
        });
      }
    };


    function observeNewNodes($el) {
      var observerStrategy;
      if (typeof MutationObserver !== 'undefined') {
        observerStrategy = observerStrategies.mutationObserver;
      } else {
        observerStrategy = observerStrategies.mutationEvent;
      }
      observerStrategy($el);
    };

    return {
      initializePresenters: initializePresenters,
      observeNewNodes: observeNewNodes
    };
  })();

  var present = function($el){
    ns.Presenter.observeNewNodes($el);
    ns.Presenter.initializePresenters($el);
  };

  ns.present = present;
})(jQuery, window);
