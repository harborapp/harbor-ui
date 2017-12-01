package handler

import (
	"fmt"
	"net/http"

	"github.com/go-kit/kit/log"
	"github.com/umschlag/umschlag-ui/pkg/assets"
	"github.com/umschlag/umschlag-ui/pkg/config"
)

// Static handles the delivery of all static assets.
func Static(logger log.Logger) http.Handler {
	return http.StripPrefix(
		fmt.Sprintf(
			"%sassets",
			config.Server.Root,
		),
		http.FileServer(
			assets.Load(logger),
		),
	)
}