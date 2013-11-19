(function() {
  goog.provide('gn_ows_service');


  var module = angular.module('gn_ows_service', [
  ]);

  module.provider('gnOwsCapabilities', function() {
    this.$get = ['$http', 'gnUrlUtils', '$q',
                 function($http, gnUrlUtils, $q) {

        var displayFileContent = function(data) {
          var layers = [];
          var layerSelected = null; // the layer selected on user click
          var layerHovered = null; // the layer when mouse is over it

          try {
            var parser = new ol.parser.ogc.WMSCapabilities();
            var result = parser.read(data);

            // We don't add the root layer node in the list
            for (var i = 0, len = result.capability.layers.length - 1;
                i < len; i++) {
              var layer = result.capability.layers[i];

              // If the  WMS layer has no name or if it can't be
              // displayed in the current SRS, we don't add it
              // to the list
              if (layer.name) {
                layers.push(layer);
              }
            }
            return layers;
          } catch (e) {
            console.log('error parsing WMSCapabilities');
          }

        };
        return {
          getCapabilities: function(url) {
            url = 'http://wms.geo.admin.ch/' +
                '?SERVICE=WMS&REQUEST=GetCapabilities&VERSION=1.3.0';

            var defer = $q.defer();
            if (gnUrlUtils.isValid(url)) {
              var proxyUrl = '../../proxy?url=' + encodeURIComponent(url);
              $http.get(proxyUrl)
                .success(function(data, status, headers, config) {
                    defer.resolve(displayFileContent(data));
                  })
                .error(function(data, status, headers, config) {
                    defer.reject(error);
                  });
            }
            return defer.promise;
          }
        };
      }];
  });
})();