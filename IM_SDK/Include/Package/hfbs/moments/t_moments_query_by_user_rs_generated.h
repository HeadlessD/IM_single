// automatically generated by the FlatBuffers compiler, do not modify

#ifndef FLATBUFFERS_GENERATED_TMOMENTSQUERYBYUSERRS_MOMENTSPACK_H_
#define FLATBUFFERS_GENERATED_TMOMENTSQUERYBYUSERRS_MOMENTSPACK_H_

#include "flatbuffers.h"

#include "common_generated.h"
#include "t_moments_common_generated.h"

namespace momentspack {

struct T_MOMENTS_ARTICLE_QUERY_BY_USER_RS;

struct T_MOMENTS_ARTICLE_QUERY_BY_USER_RS FLATBUFFERS_FINAL_CLASS : private flatbuffers::Table {
  enum {
    VT_S_RS_HEAD = 4,
    VT_ARTICLES = 6
  };
  const commonpack::S_RS_HEAD *s_rs_head() const { return GetStruct<const commonpack::S_RS_HEAD *>(VT_S_RS_HEAD); }
  const flatbuffers::Vector<flatbuffers::Offset<momentspack::T_MOMENTS_ARTICLE_DTO>> *articles() const { return GetPointer<const flatbuffers::Vector<flatbuffers::Offset<momentspack::T_MOMENTS_ARTICLE_DTO>> *>(VT_ARTICLES); }
  bool Verify(flatbuffers::Verifier &verifier) const {
    return VerifyTableStart(verifier) &&
           VerifyField<commonpack::S_RS_HEAD>(verifier, VT_S_RS_HEAD) &&
           VerifyField<flatbuffers::uoffset_t>(verifier, VT_ARTICLES) &&
           verifier.Verify(articles()) &&
           verifier.VerifyVectorOfTables(articles()) &&
           verifier.EndTable();
  }
};

struct T_MOMENTS_ARTICLE_QUERY_BY_USER_RSBuilder {
  flatbuffers::FlatBufferBuilder &fbb_;
  flatbuffers::uoffset_t start_;
  void add_s_rs_head(const commonpack::S_RS_HEAD *s_rs_head) { fbb_.AddStruct(T_MOMENTS_ARTICLE_QUERY_BY_USER_RS::VT_S_RS_HEAD, s_rs_head); }
  void add_articles(flatbuffers::Offset<flatbuffers::Vector<flatbuffers::Offset<momentspack::T_MOMENTS_ARTICLE_DTO>>> articles) { fbb_.AddOffset(T_MOMENTS_ARTICLE_QUERY_BY_USER_RS::VT_ARTICLES, articles); }
  T_MOMENTS_ARTICLE_QUERY_BY_USER_RSBuilder(flatbuffers::FlatBufferBuilder &_fbb) : fbb_(_fbb) { start_ = fbb_.StartTable(); }
  T_MOMENTS_ARTICLE_QUERY_BY_USER_RSBuilder &operator=(const T_MOMENTS_ARTICLE_QUERY_BY_USER_RSBuilder &);
  flatbuffers::Offset<T_MOMENTS_ARTICLE_QUERY_BY_USER_RS> Finish() {
    auto o = flatbuffers::Offset<T_MOMENTS_ARTICLE_QUERY_BY_USER_RS>(fbb_.EndTable(start_, 2));
    return o;
  }
};

inline flatbuffers::Offset<T_MOMENTS_ARTICLE_QUERY_BY_USER_RS> CreateT_MOMENTS_ARTICLE_QUERY_BY_USER_RS(flatbuffers::FlatBufferBuilder &_fbb,
    const commonpack::S_RS_HEAD *s_rs_head = 0,
    flatbuffers::Offset<flatbuffers::Vector<flatbuffers::Offset<momentspack::T_MOMENTS_ARTICLE_DTO>>> articles = 0) {
  T_MOMENTS_ARTICLE_QUERY_BY_USER_RSBuilder builder_(_fbb);
  builder_.add_articles(articles);
  builder_.add_s_rs_head(s_rs_head);
  return builder_.Finish();
}

inline flatbuffers::Offset<T_MOMENTS_ARTICLE_QUERY_BY_USER_RS> CreateT_MOMENTS_ARTICLE_QUERY_BY_USER_RSDirect(flatbuffers::FlatBufferBuilder &_fbb,
    const commonpack::S_RS_HEAD *s_rs_head = 0,
    const std::vector<flatbuffers::Offset<momentspack::T_MOMENTS_ARTICLE_DTO>> *articles = nullptr) {
  return CreateT_MOMENTS_ARTICLE_QUERY_BY_USER_RS(_fbb, s_rs_head, articles ? _fbb.CreateVector<flatbuffers::Offset<momentspack::T_MOMENTS_ARTICLE_DTO>>(*articles) : 0);
}

inline const momentspack::T_MOMENTS_ARTICLE_QUERY_BY_USER_RS *GetT_MOMENTS_ARTICLE_QUERY_BY_USER_RS(const void *buf) {
  return flatbuffers::GetRoot<momentspack::T_MOMENTS_ARTICLE_QUERY_BY_USER_RS>(buf);
}

inline bool VerifyT_MOMENTS_ARTICLE_QUERY_BY_USER_RSBuffer(flatbuffers::Verifier &verifier) {
  return verifier.VerifyBuffer<momentspack::T_MOMENTS_ARTICLE_QUERY_BY_USER_RS>(nullptr);
}

inline void FinishT_MOMENTS_ARTICLE_QUERY_BY_USER_RSBuffer(flatbuffers::FlatBufferBuilder &fbb, flatbuffers::Offset<momentspack::T_MOMENTS_ARTICLE_QUERY_BY_USER_RS> root) {
  fbb.Finish(root);
}

}  // namespace momentspack

#endif  // FLATBUFFERS_GENERATED_TMOMENTSQUERYBYUSERRS_MOMENTSPACK_H_
