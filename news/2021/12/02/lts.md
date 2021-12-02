@def rss_pubdate = Date(2021,12,2)
@def rss = """SciML's Stance on Long Term Support (LTS)"""
@def published = " 2 December 2021 "
@def title = "SciML's Stance on Long Term Support (LTS)"
@def authors = """<a href="https://github.com/ChrisRackauckas">Chris Rackauckas</a>"""

# SciML's Stance on Long Term Support (LTS)

Long-term support is always a balance between spending time developing new
exciting features and supporting older Julia versions to allow users to
more easily keep up. In the v1.0 LTS era and the Julia v0.x times, SciML has
explicitly not supported the Julia LTS for multiple reasons, mostly because
the later Julia versions included lots of bug fixes specifically designed for
the SciML repositories (making Julia v1.0 LTS tenuous to use even until its last
day!).

However, with Julia v1.6 becoming the new LTS, a version which all libraries
fully support, SciML is adopting the position of supporting the LTS. This means
that the following strategies will be employed:

- All packages will be tested on the current Julia release (currently v1.7) and LTS
- All packages will be given a minimum version of the LTS
- No Julia versions before the LTS will be supported. Feel free to ask questions
  but issues and bug reports from pre-v1.6 Julia versions which cannot be reproduced
  on Julia LTS will be closed.
- All benchmarks, tutorials, etc. will continue to be generated on the current
  Julia release (currently v1.7)
- Version compatibility handling will ensure that the LTS-compatible version
  continues to have all functionality and pass all tests. However, that does not
  mean that the LTS is recommended. In many cases, version-based branching may
  be required for compatibility but disable performance, compile-time, or
  stability enhancements. Thus we recommend all users use the current Julia
  release unless the LTS is specifically required for support reasons.

Lastly, we encourage other organizations to adopt a similar strategy.

One last note, please do not mix up the concepts of reproducibility and
long-term support in issues discussing this topic. Reproducibility is for
recreating a known analysis. For personal projects, we recommend simply using a
Manifest.toml for reproducibility which will work on any version of Julia beyond
v1.0. Long-term support is for continually updating/changing projects (usually
managed by large organizations or teams) which do not have the manpower for
version updates due to labor cost, which can justify the missing performance
etc. to compensate. These are two different concepts which entirely different
tooling.
