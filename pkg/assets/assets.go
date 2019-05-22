package assets

import (
	"net/http"
	"os"
	"path"

	"github.com/rs/zerolog/log"
	"github.com/umschlag/umschlag-ui/pkg/config"
)

//go:generate gorunpkg github.com/UnnoTed/fileb0x ab0x.yaml

// Load initializes the static files.
func Load(cfg *config.Config) http.FileSystem {
	return ChainedFS{
		config: cfg,
	}
}

// ChainedFS is a simple HTTP filesystem including custom path.
type ChainedFS struct {
	config *config.Config
}

// Open just implements the HTTP filesystem interface.
func (c ChainedFS) Open(origPath string) (http.File, error) {
	if c.config.Server.Static != "" {
		if stat, err := os.Stat(c.config.Server.Static); err == nil && stat.IsDir() {
			customPath := path.Join(
				c.config.Server.Static,
				"assets",
				origPath,
			)

			if _, err := os.Stat(customPath); !os.IsNotExist(err) {
				f, err := os.Open(customPath)

				if err != nil {
					return nil, err
				}

				return f, nil
			}
		} else {
			log.Warn().
				Msg("custom assets directory doesn't exist")
		}
	}

	f, err := FS.OpenFile(CTX, origPath, os.O_RDONLY, 0644)

	if err != nil {
		return nil, err
	}

	return f, nil
}
