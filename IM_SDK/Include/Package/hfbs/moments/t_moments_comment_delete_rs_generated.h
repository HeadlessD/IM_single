// automatically generated by the FlatBuffers compiler, do not modify

#ifndef FLATBUFFERS_GENERATED_TMOMENTSCOMMENTDELETERS_MOMENTSPACK_H_
#define FLATBUFFERS_GENERATED_TMOMENTSCOMMENTDELETERS_MOMENTSPACK_H_

#include "flatbuffers.h"

#include "common_generated.h"

namespace momentspack {

struct T_MOMENTS_COMMENT_DELETE_RS;

struct T_MOMENTS_COMMENT_DELETE_RS FLATBUFFERS_FINAL_CLASS : private flatbuffers::Table {
  enum {
    VT_S_RS_HEAD = 4,
    VT_ARTICLE_USER_ID = 6,
    VT_ARTICLE_ID = 8,
    VT_USER_ID = 10,
    VT_COMMENT_ID = 12
  };
  const commonpack::S_RS_HEAD *s_rs_head() const { return GetStruct<const commonpack::S_RS_HEAD *>(VT_S_RS_HEAD); }
  uint64_t article_user_id() const { return GetField<uint64_t>(VT_ARTICLE_USER_ID, 0); }
  uint64_t article_id() const { return GetField<uint64_t>(VT_ARTICLE_ID, 0); }
  uint64_t user_id() const { return GetField<uint64_t>(VT_USER_ID, 0); }
  uint64_t comment_id() const { return GetField<uint64_t>(VT_COMMENT_ID, 0); }
  bool Verify(flatbuffers::Verifier &verifier) const {
    return VerifyTableStart(verifier) &&
           VerifyField<commonpack::S_RS_HEAD>(verifier, VT_S_RS_HEAD) &&
           VerifyField<uint64_t>(verifier, VT_ARTICLE_USER_ID) &&
           VerifyField<uint64_t>(verifier, VT_ARTICLE_ID) &&
           VerifyField<uint64_t>(verifier, VT_USER_ID) &&
           VerifyField<uint64_t>(verifier, VT_COMMENT_ID) &&
           verifier.EndTable();
  }
};

struct T_MOMENTS_COMMENT_DELETE_RSBuilder {
  flatbuffers::FlatBufferBuilder &fbb_;
  flatbuffers::uoffset_t start_;
  void add_s_rs_head(const commonpack::S_RS_HEAD *s_rs_head) { fbb_.AddStruct(T_MOMENTS_COMMENT_DELETE_RS::VT_S_RS_HEAD, s_rs_head); }
  void add_article_user_id(uint64_t article_user_id) { fbb_.AddElement<uint64_t>(T_MOMENTS_COMMENT_DELETE_RS::VT_ARTICLE_USER_ID, article_user_id, 0); }
  void add_article_id(uint64_t article_id) { fbb_.AddElement<uint64_t>(T_MOMENTS_COMMENT_DELETE_RS::VT_ARTICLE_ID, article_id, 0); }
  void add_user_id(uint64_t user_id) { fbb_.AddElement<uint64_t>(T_MOMENTS_COMMENT_DELETE_RS::VT_USER_ID, user_id, 0); }
  void add_comment_id(uint64_t comment_id) { fbb_.AddElement<uint64_t>(T_MOMENTS_COMMENT_DELETE_RS::VT_COMMENT_ID, comment_id, 0); }
  T_MOMENTS_COMMENT_DELETE_RSBuilder(flatbuffers::FlatBufferBuilder &_fbb) : fbb_(_fbb) { start_ = fbb_.StartTable(); }
  T_MOMENTS_COMMENT_DELETE_RSBuilder &operator=(const T_MOMENTS_COMMENT_DELETE_RSBuilder &);
  flatbuffers::Offset<T_MOMENTS_COMMENT_DELETE_RS> Finish() {
    auto o = flatbuffers::Offset<T_MOMENTS_COMMENT_DELETE_RS>(fbb_.EndTable(start_, 5));
    return o;
  }
};

inline flatbuffers::Offset<T_MOMENTS_COMMENT_DELETE_RS> CreateT_MOMENTS_COMMENT_DELETE_RS(flatbuffers::FlatBufferBuilder &_fbb,
    const commonpack::S_RS_HEAD *s_rs_head = 0,
    uint64_t article_user_id = 0,
    uint64_t article_id = 0,
    uint64_t user_id = 0,
    uint64_t comment_id = 0) {
  T_MOMENTS_COMMENT_DELETE_RSBuilder builder_(_fbb);
  builder_.add_comment_id(comment_id);
  builder_.add_user_id(user_id);
  builder_.add_article_id(article_id);
  builder_.add_article_user_id(article_user_id);
  builder_.add_s_rs_head(s_rs_head);
  return builder_.Finish();
}

inline const momentspack::T_MOMENTS_COMMENT_DELETE_RS *GetT_MOMENTS_COMMENT_DELETE_RS(const void *buf) {
  return flatbuffers::GetRoot<momentspack::T_MOMENTS_COMMENT_DELETE_RS>(buf);
}

inline bool VerifyT_MOMENTS_COMMENT_DELETE_RSBuffer(flatbuffers::Verifier &verifier) {
  return verifier.VerifyBuffer<momentspack::T_MOMENTS_COMMENT_DELETE_RS>(nullptr);
}

inline void FinishT_MOMENTS_COMMENT_DELETE_RSBuffer(flatbuffers::FlatBufferBuilder &fbb, flatbuffers::Offset<momentspack::T_MOMENTS_COMMENT_DELETE_RS> root) {
  fbb.Finish(root);
}

}  // namespace momentspack

#endif  // FLATBUFFERS_GENERATED_TMOMENTSCOMMENTDELETERS_MOMENTSPACK_H_
